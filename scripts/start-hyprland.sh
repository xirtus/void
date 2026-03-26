#!/bin/bash

# NVIDIA Environment Variables for Hyprland
export LIBVA_DRIVER_NAME=nvidia
export XDG_SESSION_TYPE=wayland
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export WLR_NO_HARDWARE_CURSORS=1

# Important XDG setup (adjusting based on your river script)
export XDG_RUNTIME_DIR=/tmp/runtime-xirtus
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# Optional: GDK and QT Wayland Backend (if packages are installed)
# export GDK_BACKEND=wayland
# export QT_QPA_PLATFORM=wayland

exec dbus-run-session Hyprland
