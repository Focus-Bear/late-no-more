#!/bin/bash
# Unit tests for AlertHours, the last section of swift-app/Late No More/EventWarningManager.swift: compiles
# that section on its own with swiftc and runs swift-app/Tests/AlertHours. No Xcode project or test target needed.
set -euo pipefail
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
source_file="$repo_root/swift-app/Late No More/EventWarningManager.swift"
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

{ echo "import Foundation"; sed -n '/^\/\/ MARK: - AlertHours/,$p' "$source_file"; } > "$work_dir/AlertHours.swift"
xcrun swiftc "$work_dir/AlertHours.swift" "$repo_root/swift-app/Tests/AlertHours/main.swift" -o "$work_dir/test-alert-hours"
"$work_dir/test-alert-hours"
