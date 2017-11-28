#!/bin/bash

# exit if a command fails
set -e
#
# Required parameters
if [ -z "${info_plist_file}" ] ; then
  echo " [!] Missing required input: info_plist_file"
  echo " [!] Exiting..."
  exit 1
fi
if [ ! -f "${info_plist_file}" ] ; then
  echo " [!] File Info.plist doesn't exist at specified path: ${info_plist_file}"
  echo " [!] Exiting..."
  exit 1
fi

if [ -z "${append_version}" ] ; then
  echo " [!] No append_version specified!"
  exit 1
fi

if [ -z "${bundle_version}" ] ; then
  echo " [!] No Bundle Version (bundle_version) specified!"
fi

if [ -z "${bundle_version_short}" ] ; then
  echo " [!] No Bundle Short Version String (bundle_version_short) specified!"
fi
# ---------------------
# --- Configs:

echo " (i) Provided Info.plist file path: ${info_plist_file}"
echo " (i) Provided Bundle Version: ${bundle_version}"
echo " (i) Provided Bundle Short Version String: ${bundle_version_short}"
echo " (i) Provided append version: ${append_version}"

# ---------------------
# --- Main:

# verbose / debug print commands
#set -v

# ---- Set Info.plist Bundle version:
echo ""
echo ""
echo " (i) Replacing version..."

#For backward compatibility
version_offset="${version_short_offset}"

ORIGINAL_BUNDLE_VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "${info_plist_file}")"
echo " (i) Original Bundle Version: $ORIGINAL_BUNDLE_VERSION"
ORIGINAL_BUNDLE_SHORT_VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "${info_plist_file}")"
echo " (i) Original Bundle Short Version String: $ORIGINAL_BUNDLE_SHORT_VERSION"


if [ ! -z "${version_offset}" ] ; then
  echo " (i) Version offset: ${version_offset}"
if [ ! -z "${bundle_version}" ] ; then
  bundle_version=$((${bundle_version} + ${version_offset}))
else 
  bundle_version=$((${ORIGINAL_BUNDLE_VERSION} + ${version_offset}))
fi  
fi



if [ ! -z "${bundle_version_short}" ] ; then
if [ "${append_version}" == "true" ]; then
	echo " (i) Need append version"
	if [[ "$ORIGINAL_BUNDLE_SHORT_VERSION" == *. ]]
then
    bundle_version_short=${ORIGINAL_BUNDLE_SHORT_VERSION}${bundle_version_short}
else
    bundle_version_short=${ORIGINAL_BUNDLE_SHORT_VERSION}.${bundle_version_short}
fi	
fi
else 
bundle_version_short=${ORIGINAL_BUNDLE_SHORT_VERSION}
fi


/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${bundle_version_short}" "${info_plist_file}"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${bundle_version}" "${info_plist_file}"

REPLACED_BUNDLE_VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "${info_plist_file}")"
echo " (i) Replaced Bundle Version: $REPLACED_BUNDLE_VERSION"
REPLACED_BUNDLE_SHORT_VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "${info_plist_file}")"
echo " (i) Replaced Bundle Short Version String: $REPLACED_BUNDLE_SHORT_VERSION"

envman add --key APP_BUILD --value "${REPLACED_BUNDLE_VERSION}"
envman add --key APP_VERSION --value "${REPLACED_BUNDLE_SHORT_VERSION}"

# ==> Bundler version patched in Info.plist file for iOS project
