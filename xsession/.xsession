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

exec i3
