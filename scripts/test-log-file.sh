#!/bin/bash
# Compiles LogFile.swift with its tests and runs them. The Xcode project has no test target.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT

xcrun swiftc \
  "$REPO_ROOT/swift-app/Late No More/LogFile.swift" \
  "$REPO_ROOT/swift-app/Tests/LogFile/main.swift" \
  -o "$BUILD_DIR/log-file-tests"
"$BUILD_DIR/log-file-tests"
