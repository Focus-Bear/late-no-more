#!/bin/bash
# Compiles the 15-minute reminder with its tests and runs them. The Xcode project has no test target.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT

xcrun swiftc \
  "$REPO_ROOT/swift-app/Late No More/warnUserVc.swift" \
  "$REPO_ROOT/swift-app/Tests/ReminderPanel/main.swift" \
  -o "$BUILD_DIR/reminder-panel-tests"
"$BUILD_DIR/reminder-panel-tests"
