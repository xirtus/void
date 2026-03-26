#!/bin/bash

# Ensure DBus is seeing the correct environment
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# Restart PipeWire and friends as user services if they are already running
# or let the Hyprland 'exec-once' handle them.
# We'll just ensure they're refreshed here if needed.
killall -9 pipewire wireplumber pipewire-pulse 2>/dev/null
sleep 1
pipewire &
pipewire-pulse &
wireplumber &
