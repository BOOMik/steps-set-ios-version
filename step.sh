#!/bin/bash

# exit if a command fails
set -e

#
# Required parameters
if [ -z "${info_plist_file}" ] ; then
  echo " [!] Missing required input: info_plist_file"
  exit 1
fi
if [ ! -f "${info_plist_file}" ] ; then
  echo " [!] File Info.plist doesn't exist at specified path: ${info_plist_file}"
  exit 1
fi

if [ -z "${bundle_version}" ] ; then
  echo " [!] No Bundle Version (bundle_version) specified!"
  exit 1
fi

if [ -z "${bundle_version_short}" ] ; then
  echo " [!] No Bundle Short Version String (bundle_version_short) specified!"
  exit 1
fi

# ---------------------
# --- Configs:

echo " (i) Provided Info.plist file path: ${info_plist_file}"
echo " (i) Provided Bundle Version: ${bundle_version}"
echo " (i) Provided Bundle Short Version String: ${bundle_version_short}"

# ---------------------
# --- Main:

# verbose / debug print commands
set -v

# ---- Set Info.plist Bundle version:
echo ""
echo ""
echo " (i) Replacing version..."

ORIGINAL_BUNDLE_VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "${info_plist_file}")"
echo " (i) Original Bundle Version: $ORIGINAL_BUNDLE_VERSION"
ORIGINAL_BUNDLE_SHORT_VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "${info_plist_file}")"
echo " (i) Original Bundle Short Version String: $ORIGINAL_BUNDLE_SHORT_VERSION"

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${bundle_version}" "${info_plist_file}"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${bundle_version_short}" "${info_plist_file}"

REPLACED_BUNDLE_VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "${info_plist_file}")"
echo " (i) Replaced Bundle Version: $REPLACED_BUNDLE_VERSION"
REPLACED_BUNDLE_SHORT_VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "${info_plist_file}")"
echo " (i) Replaced Bundle Short Version String: $REPLACED_BUNDLE_SHORT_VERSION"

# ==> Bundler version patched in Info.plist file for iOS project
