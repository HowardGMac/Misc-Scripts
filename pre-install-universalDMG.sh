#!/bin/bash
appName="" #name of application (i.e. Chrome, Scribus, etc)
appBinaryName="" #name of application binary (i.e. Google Chrome.app, Firefox.app, etc)

ERROR=0

#Remove old version of Application
if [[ -d "/Applications/$appBinaryName" ]]; then
  echo "Removing old version of $appName"
  rm -rf "/Applications/$appBinaryName"
fi

# File Paths

dmgFile="$(/usr/bin/find $(dirname $0) -maxdepth 1 \( -iname \*\.dmg \))"

# Mount the DMG

dmgMount="$(/usr/bin/mktemp -d /tmp/$appName.XXXX)"
/usr/bin/hdiutil attach "$dmgFile" -mountpoint "$dmgMount" -nobrowse -noverify -noautoopen

# Install the Shotcut software

cp -R "$dmgMount/$appBinaryName" /Applications
sleep 2

# Unmount the DMG

hdiutil detach $dmgMount -force

checkQuarantine=$(/usr/bin/xattr "/Applications/$appBinaryName" | grep com.apple.quarantine)

echo "Checking for quarantine flag on $appName application..."

if [[ ! -z "$checkQuarantine" ]]; then
    /usr/bin/xattr -d com.apple.quarantine "/Applications/$appBinaryName"
    echo "...Quarantine flag cleared on the $appName application."
else
    echo "...No Quarantine flag found on the $appName application."
fi

exit $ERROR
