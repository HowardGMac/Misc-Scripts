#!/bin/zsh --no-rcs
#
# Update Ruby Gem by Name
# This script will update the named Ruby Gem to the latest version.
# It will only work with the default macOS installed Ruby system (2.6.0 when written) and WILL NOT update any homebrew installed versions.
# If the default version of the gem being updated is older than the latest, it will remove the older default spec file and set the updated version as the default.
# This script was written for use with JAMF and looks for the Ruby Gem name to be provided as paramater 4. Adjust the script as needed for your use case.
#
testforgem=$(/usr/bin/gem list ${4} --installed)
if [[ $testforgem == "true" ]]; then
	echo "Specified Gem [${4}] is already installed, updating it now..."
    /usr/bin/gem update ${4}
else
	echo "Specificed Gem [${4}] not installed, nothing to update now."
    exit 0
fi

testforgemdefault=$(/usr/bin/gem list ${4}|grep "${4}")
testforgemdefault=${testforgemdefault#*\(}
testforgemdefault=${testforgemdefault%\)*}
#echo $testforgemdefault

installedGemVersion=$(echo $testforgemdefault| awk -F',' '{print $1}')
echo "Installed version: $installedGemVersion"
defaultGemVersion=${$(echo $testforgemdefault|cut -d':' -f2)// /}
echo "Default version: $defaultGemVersion"

installedGemVersionNum=${$(echo $testforgemdefault| awk -F',' '{print $1}')//[^0-9]/}
defaultGemVersionNum=${$(echo $testforgemdefault|cut -d':' -f2)//[^0-9]/}
if [[ -z $defaultGemVersionNum ]]; then
    defaultGemVersionNum=0
fi
#echo $installedversionnum
#echo $defaultversionnum
if [[ ${installedGemVersionNum:0:3} > ${defaultGemVersionNum:0:3} ]];then
    echo "Replacing default Gem with newer one..."
	/bin/rm "/Library/Ruby/Gems/2.6.0/specifications/$4-$defaultGemVersion.gemspec"
    /bin/rm /Library/Ruby/Gems/2.6.0/specifications/default/$4-*.gemspec
else
    echo "Not replacing default Gem..."
fi
echo "$(/usr/bin/gem list ${4})"
