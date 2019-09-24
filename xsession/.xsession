#!/bin/sh

# load Xresources
xrdb -merge ~/.Xresources

# necessary to make chrome pick up the proxy settings stored in gconf.
export DESKTOP_SESSION=cinnamon  # gnome for trusty.

# NOTE: this may break your compose key.
# see http://g/i3-users/YBexXGbik7E for more details.
export GTK_IM_MODULE=xim

# desktop background color.
xsetroot -solid "#333333"

export TERMINAL=alacritty

# set up keyboard and mouse
xmodmap ~/.Xmodmap
xset r rate 200 25
imwheel --kill --buttons '4 5'

# in a clean install, use i3 instead.
#
# to use i3-gaps, build and install the binary
# per the instructions in
#
# 		https://github.com/Airblader/i3/wiki/Compiling-&-Installing
#
# ;make sure the requirements for Debian Testing
# installed beforehand. Then copy the binary to a location
# in $PATH.
exec i3-gaps
