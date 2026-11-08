#!/bin/bash
set -euo pipefail

# Notarization credentials never live in this repo: notary-auth.sh reads a notarytool keychain profile
# (or APPLE_ID / APPLE_APP_PASSWORD) and its header has the one-time setup.
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/notary-auth.sh"
resolve_notary_auth

APP_PATH="Late No More.app"
ZIP_PATH="Late No More.zip"

# Create a ZIP archive suitable for notarization.
/usr/bin/ditto -c -k --keepParent "$APP_PATH" "$ZIP_PATH"

xcrun notarytool submit "$ZIP_PATH" --wait "${NOTARY_AUTH_ARGS[@]}"
