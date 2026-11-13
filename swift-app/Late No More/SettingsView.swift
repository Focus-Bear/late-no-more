//
//  SettingsView.swift
//  Late No More
//
//  The settings window. Written against the macOS 11 SDK subset (the app's deployment target), so the
//  grouped look is built from plain stacks rather than macOS 13's grouped Form.
//

import SwiftUI

enum SettingsLayout {
    static let WINDOW_WIDTH: CGFloat = 540
    static let PAGE_PADDING: CGFloat = 20
    static let SECTION_SPACING: CGFloat = 18
    static let HEADER_SPACING: CGFloat = 6
    static let CARD_PADDING: CGFloat = 12
    static let CARD_CORNER_RADIUS: CGFloat = 10
    static let ROW_SPACING: CGFloat = 6
    static let CALENDAR_LIST_HEIGHT: CGFloat = 200
    static let COLOR_DOT_SIZE: CGFloat = 10
    static let CHIP_SPACING: CGFloat = 6
    static let CHIP_HORIZONTAL_PADDING: CGFloat = 8
    static let CHIP_VERTICAL_PADDING: CGFloat = 3
    static let ADD_KEYWORD_WIDTH: CGFloat = 220
}

struct SettingsView: View {
    @ObservedObject var model: SettingsViewModel
    let onOpenAdvanced: () -> Void
    let onOpenWebsite: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SettingsLayout.SECTION_SPACING) {
            CalendarsSection(model: model)
            KeywordsSection(model: model)
            AlertHoursSection(model: model)
            GeneralSection(model: model, onOpenAdvanced: onOpenAdvanced)
            SettingsFooter(model: model, onOpenWebsite: onOpenWebsite)
        }
        .padding(SettingsLayout.PAGE_PADDING)
        .frame(width: SettingsLayout.WINDOW_WIDTH, alignment: .topLeading)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// MARK: - Building blocks

private struct SettingsSection<Content: View>: View {
    let title: String
    var summary: String?
    var footnote: String?
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: SettingsLayout.HEADER_SPACING) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                if let summary = summary {
                    Text(summary)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            VStack(alignment: .leading, spacing: SettingsLayout.ROW_SPACING, content: content)
                .padding(SettingsLayout.CARD_PADDING)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: SettingsLayout.CARD_CORNER_RADIUS, style: .continuous)
                        .fill(Color(NSColor.controlBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: SettingsLayout.CARD_CORNER_RADIUS, style: .continuous)
                        .stroke(Color(NSColor.separatorColor))
                )
            if let footnote = footnote {
                Text(footnote)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Calendars

private struct CalendarsSection: View {
    @ObservedObject var model: SettingsViewModel

    var body: some View {
        SettingsSection(
            title: SettingsText.calendarsTitle,
            summary: model.calendars.isEmpty ? nil : enabledSummary,
            footnote: SettingsText.calendarsFootnote
        ) {
            if model.calendars.isEmpty {
                Text(SettingsText.calendarsNone)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                if model.isCalendarFilterShown {
                    CalendarFilterField(query: $model.calendarQuery)
                }
                if model.isCalendarFilterShown {
                    ScrollView { calendarList.padding(.trailing, SettingsLayout.CARD_PADDING) }
                        .frame(height: SettingsLayout.CALENDAR_LIST_HEIGHT)
                } else {
                    calendarList
                }
            }
        }
    }

    private var enabledSummary: String {
        String(format: SettingsText.calendarsEnabledCountFormat, model.enabledCalendarCount, model.calendars.count)
    }

    private var calendarList: some View {
        let groups = model.visibleCalendarGroups
        return VStack(alignment: .leading, spacing: SettingsLayout.CARD_PADDING) {
            if groups.isEmpty {
                Text(String(format: SettingsText.calendarsNoMatchFormat, model.calendarQuery))
                    .foregroundColor(.secondary)
            }
            ForEach(groups) { group in
                CalendarGroupView(model: model, group: group)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct CalendarFilterField: View {
    @Binding var query: String

    var body: some View {
        HStack(spacing: SettingsLayout.ROW_SPACING) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .accessibilityHidden(true)
            TextField(SettingsText.calendarsFilterPlaceholder, text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibilityLabel(Text(SettingsText.calendarsFilterPlaceholder))
            if !query.isEmpty {
                SwiftUI.Button(action: { query = "" }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
                }
                .buttonStyle(BorderlessButtonStyle())
                .help(SettingsText.calendarsClearFilter)
                .accessibilityLabel(Text(SettingsText.calendarsClearFilter))
            }
        }
    }
}

private struct CalendarGroupView: View {
    @ObservedObject var model: SettingsViewModel
    let group: CalendarGroup

    var body: some View {
        VStack(alignment: .leading, spacing: SettingsLayout.ROW_SPACING) {
            HStack {
                Text(group.accountTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                SwiftUI.Button(model.areAllCalendarsEnabled(in: group) ? SettingsText.calendarsDeselectAll : SettingsText.calendarsSelectAll) {
                    model.toggleAllCalendars(in: group)
                }
                .buttonStyle(LinkButtonStyle())
                .font(.caption)
                .accessibilityHint(Text(String(format: SettingsText.calendarsSelectAllHintFormat, group.accountTitle)))
            }
            ForEach(group.calendars) { calendar in
                CalendarRow(model: model, calendar: calendar)
            }
        }
    }
}

private struct CalendarRow: View {
    @ObservedObject var model: SettingsViewModel
    let calendar: CalendarOption

    var body: some View {
        Toggle(isOn: Binding(
            get: { model.isCalendarEnabled(calendar) },
            set: { model.setCalendar(calendar, enabled: $0) }
        )) {
            HStack(spacing: SettingsLayout.ROW_SPACING) {
                Circle()
                    .fill(dotColor)
                    .frame(width: SettingsLayout.COLOR_DOT_SIZE, height: SettingsLayout.COLOR_DOT_SIZE)
                    .accessibilityHidden(true)
                Text(calendar.title)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .toggleStyle(CheckboxToggleStyle())
        .accessibilityLabel(Text(calendar.title))
    }

    private var dotColor: Color {
        guard let color = calendar.color else { return Color(NSColor.tertiaryLabelColor) }
        return Color(.sRGB, red: color.red, green: color.green, blue: color.blue)
    }
}

// MARK: - Keywords

private struct KeywordsSection: View {
    @ObservedObject var model: SettingsViewModel

    var body: some View {
        SettingsSection(title: SettingsText.keywordsTitle, footnote: SettingsText.keywordsFootnote) {
            if model.settings.ignoredKeywords.isEmpty {
                Text(SettingsText.keywordsEmpty).foregroundColor(.secondary)
            } else {
                KeywordChips(keywords: model.settings.ignoredKeywords, onRemove: model.removeKeyword)
            }
            HStack(spacing: SettingsLayout.ROW_SPACING) {
                TextField(SettingsText.keywordsPlaceholder, text: $model.keywordDraft, onCommit: addDraftIfPossible)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: SettingsLayout.ADD_KEYWORD_WIDTH)
                    .accessibilityLabel(Text(SettingsText.keywordsPlaceholder))
                SwiftUI.Button(SettingsText.keywordsAdd, action: addDraftIfPossible)
                    .disabled(!model.canAddKeywordDraft)
            }
            .padding(.top, SettingsLayout.ROW_SPACING)
        }
    }

    private func addDraftIfPossible() {
        guard model.canAddKeywordDraft else { return }
        model.addKeywordDraft()
    }
}

/// Wraps chips onto as many lines as they need. macOS 11 has no `Layout`, so this uses the
/// alignment-guide flow technique and measures its own height.
private struct KeywordChips: View {
    let keywords: [String]
    let onRemove: (String) -> Void
    @State private var height: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            chips(fittingWidth: geometry.size.width)
        }
        .frame(height: height)
    }

    private func chips(fittingWidth availableWidth: CGFloat) -> some View {
        var x: CGFloat = 0
        var y: CGFloat = 0
        let lastIndex = keywords.count - 1
        return ZStack(alignment: .topLeading) {
            // Indexed rather than keyed by text: a hand-edited settings file can repeat a keyword.
            ForEach(Array(keywords.enumerated()), id: \.offset) { index, keyword in
                KeywordChip(keyword: keyword, onRemove: { onRemove(keyword) })
                    .padding([.trailing, .bottom], SettingsLayout.CHIP_SPACING)
                    .alignmentGuide(.leading) { dimensions in
                        if x - dimensions.width < -availableWidth {
                            x = 0
                            y -= dimensions.height
                        }
                        let leading = x
                        x = index == lastIndex ? 0 : x - dimensions.width
                        return leading
                    }
                    .alignmentGuide(.top) { _ in
                        let top = y
                        if index == lastIndex { y = 0 }
                        return top
                    }
            }
        }
        .background(GeometryReader { proxy in
            Color.clear.preference(key: ChipsHeightKey.self, value: proxy.size.height)
        })
        .onPreferenceChange(ChipsHeightKey.self) { height = $0 }
    }
}

private struct ChipsHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct KeywordChip: View {
    let keyword: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: SettingsLayout.CHIP_VERTICAL_PADDING) {
            Text(keyword)
                .lineLimit(1)
            SwiftUI.Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption2.weight(.bold))
            }
            .buttonStyle(BorderlessButtonStyle())
            .help(String(format: SettingsText.keywordsRemoveFormat, keyword))
            .accessibilityLabel(Text(String(format: SettingsText.keywordsRemoveFormat, keyword)))
        }
        .padding(.horizontal, SettingsLayout.CHIP_HORIZONTAL_PADDING)
        .padding(.vertical, SettingsLayout.CHIP_VERTICAL_PADDING)
        .background(Capsule().fill(Color.accentColor.opacity(0.18)))
        .overlay(Capsule().stroke(Color.accentColor.opacity(0.35)))
    }
}

// MARK: - Alert hours

private struct AlertHoursSection: View {
    @ObservedObject var model: SettingsViewModel

    var body: some View {
        SettingsSection(title: SettingsText.hoursTitle, footnote: SettingsText.hoursFootnote) {
            HStack(spacing: SettingsLayout.ROW_SPACING) {
                Text(SettingsText.hoursBetween)
                timePicker(SettingsText.hoursStartLabel, time: $model.settings.alertStartTime)
                Text(SettingsText.hoursAnd)
                timePicker(SettingsText.hoursEndLabel, time: $model.settings.alertEndTime)
            }
            if model.settings.isAlertWindowEmpty {
                Label(SettingsText.hoursEmptyWindowWarning, systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func timePicker(_ label: String, time: Binding<TimeOfDay>) -> some View {
        DatePicker(label, selection: Binding(
            get: { time.wrappedValue.date() },
            set: { time.wrappedValue = TimeOfDay(date: $0) }
        ), displayedComponents: .hourAndMinute)
            .datePickerStyle(StepperFieldDatePickerStyle())
            .labelsHidden()
            .fixedSize()
            .accessibilityLabel(Text(label))
    }
}

// MARK: - General

private struct GeneralSection: View {
    @ObservedObject var model: SettingsViewModel
    let onOpenAdvanced: () -> Void

    var body: some View {
        SettingsSection(title: SettingsText.generalTitle) {
            HStack {
                Text(SettingsText.launchAtLogin)
                Spacer()
                Toggle(SettingsText.launchAtLogin, isOn: $model.launchesAtLogin)
                    .toggleStyle(SwitchToggleStyle())
                    .labelsHidden()
                    .accessibilityLabel(Text(SettingsText.launchAtLogin))
            }
            Divider()
            HStack {
                Text(SettingsText.advancedDescription)
                    .foregroundColor(.secondary)
                Spacer()
                SwiftUI.Button(SettingsText.advancedButton, action: onOpenAdvanced)
            }
        }
    }
}

// MARK: - Footer

private struct SettingsFooter: View {
    @ObservedObject var model: SettingsViewModel
    let onOpenWebsite: () -> Void

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: SettingsLayout.ROW_SPACING) {
            saveStatus
            Spacer()
            Text(SettingsText.broughtToYouBy)
            SwiftUI.Button(SettingsText.focusBearLink, action: onOpenWebsite)
                .buttonStyle(LinkButtonStyle())
                .foregroundColor(.accentColor)
            Text(SettingsText.footerSeparator).accessibilityHidden(true)
            Text(String(format: SettingsText.versionFormat, model.versionDescription))
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }

    private var saveStatus: some View {
        let isSaved = model.hasSavedThisSession && !model.hasUnsavedChanges
        return Label(
            isSaved ? SettingsText.saved : SettingsText.savedAutomatically,
            systemImage: isSaved ? "checkmark.circle.fill" : "arrow.triangle.2.circlepath"
        )
    }
}
