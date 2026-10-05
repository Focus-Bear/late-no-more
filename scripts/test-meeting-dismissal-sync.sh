#!/bin/bash
# Checks the Focus Bear dismissal bridge (MeetingDismissalSync.swift) without building the app:
# matching, the registry, the userInfo payload, and a real round trip over the distributed
# notification center. The stubs stand in for the view controllers the bridge closes.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HARNESS="$ROOT/scripts/meeting-dismissal-sync-harness"
OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT
xcrun swiftc -o "$OUT/harness" "$HARNESS/stubs.swift" "$HARNESS/main.swift" \
  "$ROOT/swift-app/Late No More/MeetingDismissalSync.swift"
"$OUT/harness" | grep -v '^log:'
