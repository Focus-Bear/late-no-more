#!/bin/bash
# Compiles the settings window's model with its tests and runs them. The Xcode project has no test target.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT

xcrun swiftc \
  "$REPO_ROOT/swift-app/Late No More/SettingsModel.swift" \
  "$REPO_ROOT/swift-app/Late No More/SettingsViewModel.swift" \
  "$REPO_ROOT/swift-app/Tests/SettingsModel/main.swift" \
  -o "$BUILD_DIR/settings-model-tests"
"$BUILD_DIR/settings-model-tests"
