#!/bin/zsh --no-rcs

echo "Checking for update(s)..."
availableUpdates=$(/usr/sbin/softwareupdate -la)
safariUpdateToDownload=$(echo $availableUpdates|grep "Label: Safari"|cut -d: -f2-|awk '{$1=$1;print}')
xcodecliUpdateToDownload=$(echo $availableUpdates|grep "Label: Command"|cut -d: -f2-|awk '{$1=$1;print}')

if [[ ! -z "$safariUpdateToDownload" ]]; then
    echo "...Found needed Safari update...Installing..."
    /usr/sbin/softwareupdate --install "$safariUpdateToDownload"
fi

if [[ ! -z "$xcodecliUpdateToDownload" ]]; then
    echo "...Found needed XCode Command Line Tools update...Installing..."
    /usr/sbin/softwareupdate --install "$xcodecliUpdateToDownload"
fi

echo "...Done."
