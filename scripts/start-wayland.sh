#!/bin/bash

# NVIDIA and Wayland environment variables
export LIBVA_DRIVER_NAME=nvidia
export XDG_SESSION_TYPE=wayland
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export WLR_NO_HARDWARE_CURSORS=1

# XDG Desktop Environment hints
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_DESKTOP=Hyprland

# Use existing XDG_RUNTIME_DIR if available, otherwise set a fallback
if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
fi

# Launch Hyprland within a D-Bus session
exec dbus-run-session Hyprland
