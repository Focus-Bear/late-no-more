#!/bin/bash
set -euo pipefail   # stop at the first failed step

# Name of the package.
NAME="Late No More"

# Once installed the identifier is used as the filename for a receipt files in /var/db/receipts/.
IDENTIFIER="com.focusbear.latenomore"

# Package version number.
VERSION="1.0"

# Notarization credentials live in the keychain, never in this file.
# One-time setup per machine (App Store Connect API key):
#   xcrun notarytool store-credentials "LNM_NOTARY" --key ~/.private_keys/AuthKey_<KeyID>.p8 --key-id <KeyID> --issuer <IssuerID>
NOTARY_PROFILE="${NOTARY_PROFILE:-LNM_NOTARY}"

productbuild --distribution Distribution.xml --package-path "$NAME-$VERSION.pkg" --resources resources "$NAME.pkg" --sign "Developer ID Installer: Focus Bear Pty Ltd (TCUD568B3U)"

# Verify the installer signature
pkgutil --check-signature "$NAME.pkg"

xcrun notarytool submit "$NAME.pkg" --wait --keychain-profile "$NOTARY_PROFILE"

xcrun stapler staple "$NAME.pkg"

spctl --assess -vv --type install "$NAME.pkg"
