#!/bin/bash
set -euo pipefail

# Notarization credentials never live in this repo: notary-auth.sh reads a notarytool keychain profile
# (or APPLE_ID / APPLE_APP_PASSWORD) and its header has the one-time setup.
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/notary-auth.sh"
resolve_notary_auth

# Name of the package.
NAME="Late No More"

# Once installed the identifier is used as the filename for a receipt files in /var/db/receipts/.
IDENTIFIER="com.focusbear.latenomore"

# Package version number.
VERSION="1.0"

productbuild --distribution Distribution.xml --package-path "$NAME-$VERSION.pkg"  --resources resources "Late No More.pkg" --sign "Developer ID Installer: Jeremy Nagel (TCUD568B3U)"
 
# Sign the final pkg
codesign -f -s "Developer ID Application: Jeremy Nagel (TCUD568B3U)" -v "Late No More.pkg"

#Verify Sign
codesign -vvv --deep --strict "Late No More.pkg"

xcrun notarytool submit "Late No More.pkg" --wait "${NOTARY_AUTH_ARGS[@]}"

xcrun stapler staple "Late No More.pkg"

spctl --assess -vv --type install "Late No More.pkg"
