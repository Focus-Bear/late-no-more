#!/bin/bash
set -euo pipefail

codesign -s "Developer ID Application: Jeremy Nagel (TCUD568B3U)" -o runtime --timestamp -f latenomore --entitlements neededToRun.entitlements
