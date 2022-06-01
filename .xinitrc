#!/bin/sh
userresources=$HOME/.Xresources
userbindkeys=$HOME/.xbindkeysrc
usermodmap=$HOME/.Xmodmap

# propagate DISPLAY and XAUTHORITY to dbus-daemon and, if present, systemd, 
# and propagate DBUS_SESSION_BUS_ADDRESS to systemd
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# config parameters for X client applications
if [ -f $userresources ]; then
    xrdb -merge $userresources
fi

# bind commands to certain keys or key combos
if [ -f $userbindkeys ]; then
	xbindkeys -p
fi

# key mappings
if [ -f $usermodmap ]; then
    xmodmap $usermodmap
fi

# disable system beep
xset b off

# set keyboard layout to colemak
# setxkbmap -model pc104 -layout us -variant colemak

# configure trackpoint
# if command -v $(xinput list | grep 'TrackPoint' &> /dev/null); then
#     xinput set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Speed" 1.0
# fi

# janitor
# if [ -d ~/.local/share/Trash ]; then
# 	rm -rf ~/.local/share/Trash/*
# fi

# start window manager
exec openbox-session
