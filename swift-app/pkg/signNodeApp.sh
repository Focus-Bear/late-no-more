#!/bin/bash

APP_PATH="LateNoMore"
ZIP_PATH="LateNoMore.zip"

#codesign -f --timestamp -s "Developer ID Application: Jeremy Nagel (TCUD568B3U)" -v "$APP_PATH"

codesign -s "Developer ID Application: Jeremy Nagel (TCUD568B3U)" -o runtime --timestamp -f latenomore --entitlements neededToRun.entitlements

# Create a ZIP archive suitable for notarization.
#/usr/bin/ditto -c -k --keepParent "$APP_PATH" "$ZIP_PATH"

#codesign -f -s "Developer ID Application: Jeremy Nagel (TCUD568B3U)" -v "$ZIP_PATH"

#xcrun notarytool submit "$APP_PATH" --wait --apple-id "vishnu.wtl@gmail.com" --password "mmnz-xeky-xmrt-eqgb" --team-id TCUD568B3U




# Name of the package.
#NAME="Focus Bear"

# Once installed the identifier is used as the filename for a receipt files in /var/db/receipts/.
#IDENTIFIER="com.App.EarnYourScreentime"

# Package version number.
#VERSION="1.0"

#productbuild --distribution Distribution.xml --package-path "$NAME-$VERSION.pkg"  --resources resources "Focus Bear.pkg" --sign "Developer ID Installer: Jeremy Nagel (TCUD568B3U)"
 
# Sign the final pkg
#codesign -f -s "Developer ID Application: Jeremy Nagel (TCUD568B3U)" -v "Focus Bear.pkg"

#Verify Sign
#codesign -vvv --deep --strict "Focus Bear.pkg"

#xcrun notarytool submit "Focus Bear.pkg" --wait --apple-id "vishnu.wtl@gmail.com" --password "mmnz-xeky-xmrt-eqgb" --team-id TCUD568B3U

#xcrun stapler staple "Focus Bear.pkg"

#spctl --assess -vv --type install "Focus Bear.pkg"

# Notarize the final pkg
#xcrun altool --notarize-app --primary-bundle-id "com.App.EarnYourScreentime" --username "vishnu.wtl@gmail.com" --password "mmnz-xeky-xmrt-eqgb" --asc-provider TCUD568B3U --file "Focus Bear.pkg"

# Staple the notarized pkg
#xcrun stapler staple "Focus Bear.pkg"

# Check stapled
#spctl -a -vv -t install "Focus Bear.pkg"
