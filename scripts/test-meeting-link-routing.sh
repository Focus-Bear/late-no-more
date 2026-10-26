#!/bin/bash
# Compiles MeetingLinkRouting.swift with its tests and runs them. The Xcode project has no test target.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT

xcrun swiftc \
  "$REPO_ROOT/swift-app/Late No More/MeetingLinkRouting.swift" \
  "$REPO_ROOT/swift-app/Tests/MeetingLinkRouting/main.swift" \
  -o "$BUILD_DIR/meeting-link-routing-tests"
"$BUILD_DIR/meeting-link-routing-tests"
