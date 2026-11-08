#!/bin/bash
# Compiles MeetingReminderCountdown.swift with its tests and runs them. The Xcode project has no test target.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT

xcrun swiftc \
  "$REPO_ROOT/swift-app/Late No More/MeetingReminderCountdown.swift" \
  "$REPO_ROOT/swift-app/Tests/MeetingReminderCountdown/main.swift" \
  -o "$BUILD_DIR/meeting-reminder-countdown-tests"
"$BUILD_DIR/meeting-reminder-countdown-tests"
