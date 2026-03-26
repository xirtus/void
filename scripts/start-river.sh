#!/bin/sh

# [ -z "$XDG_RUNTIME_DIR" ]; then
	export XDG_RUNTIME_DIR=/tmp/runtime-xirtus
#	if [ ! -d "XDG_RUNTIME_DIR: ]; then	
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR



# Fix standard Wayland and River environment identifers
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=river
# export WAYLAND_DISPLAY=wayland-0 # force define the socket name

# Graphics Offloading and Drivers
# We leave these unset or set to intel defaults
export LIBVA_DRIVER_NAME=iHD

# Fix invisible/flickering cursors on NVIDIA
export WLR_NO_HARDWARE_CURSORS=1

# Execution
exec river
# -c ~/.config/river/init
