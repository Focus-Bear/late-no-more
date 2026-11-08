#!/bin/bash
#
# Notarization credentials for `xcrun notarytool`, shared by 2build.sh and signSwiftApp.sh.
# Source it, then pass "${NOTARY_AUTH_ARGS[@]}" to notarytool:
#
#     source "$(dirname "$0")/notary-auth.sh"
#     resolve_notary_auth
#     xcrun notarytool submit "Late No More.pkg" --wait "${NOTARY_AUTH_ARGS[@]}"
#
# Credentials never live in this repo. In order of preference:
#
#   1. A keychain profile (recommended). One-time setup on the build Mac — notarytool prompts for the
#      app-specific password, so it never lands in shell history:
#
#          xcrun notarytool store-credentials focusbear-notary \
#            --apple-id <apple-id-email> --team-id TCUD568B3U
#
#      The scripts use the profile named by NOTARY_PROFILE, default `focusbear-notary`.
#
#   2. Environment variables, for machines without the profile (e.g. CI secrets):
#        APPLE_ID            - Apple ID used for notarization
#        APPLE_APP_PASSWORD  - app-specific password for that Apple ID (appleid.apple.com)
#        APPLE_TEAM_ID       - team id, defaults to TCUD568B3U
#      These reach notarytool as command-line arguments, which other local users can see in `ps`,
#      which is why the keychain profile comes first.

readonly DEFAULT_NOTARY_PROFILE="focusbear-notary"
readonly DEFAULT_APPLE_TEAM_ID="TCUD568B3U"
# Where `notarytool store-credentials` keeps a profile in the login keychain.
readonly NOTARY_KEYCHAIN_SERVICE="com.apple.gke.notary.tool"
readonly NOTARY_KEYCHAIN_ACCOUNT_PREFIX="com.apple.gke.notary.tool.saved-creds."

NOTARY_AUTH_ARGS=()

# Checks the profile's keychain item exists without reading its secret (no -w), so it never prompts.
notary_profile_exists() {
  security find-generic-password -s "$NOTARY_KEYCHAIN_SERVICE" \
    -a "$NOTARY_KEYCHAIN_ACCOUNT_PREFIX$1" > /dev/null 2>&1
}

has_notary_env_credentials() {
  [ -n "${APPLE_ID:-}" ] && [ -n "${APPLE_APP_PASSWORD:-}" ]
}

print_notary_setup_help() {
  cat >&2 <<EOF
error: no notarization credentials are configured.
Store them once in a keychain profile (notarytool prompts for the app-specific password):
    xcrun notarytool store-credentials $DEFAULT_NOTARY_PROFILE --apple-id <apple-id-email> --team-id $DEFAULT_APPLE_TEAM_ID
or export APPLE_ID and APPLE_APP_PASSWORD (and optionally APPLE_TEAM_ID).
If the profile exists under another name, or the keychain lookup misses it, set NOTARY_PROFILE=<name>.
EOF
}

# Fills NOTARY_AUTH_ARGS, or exits with setup instructions when nothing is configured.
resolve_notary_auth() {
  if [ -n "${NOTARY_PROFILE:-}" ]; then
    NOTARY_AUTH_ARGS=(--keychain-profile "$NOTARY_PROFILE")
    return
  fi
  if notary_profile_exists "$DEFAULT_NOTARY_PROFILE"; then
    NOTARY_AUTH_ARGS=(--keychain-profile "$DEFAULT_NOTARY_PROFILE")
    return
  fi
  if has_notary_env_credentials; then
    NOTARY_AUTH_ARGS=(--apple-id "$APPLE_ID" --password "$APPLE_APP_PASSWORD"
      --team-id "${APPLE_TEAM_ID:-$DEFAULT_APPLE_TEAM_ID}")
    return
  fi
  print_notary_setup_help
  exit 1
}
