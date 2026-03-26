#!/bin/sh

sleep 1

# Kill any old/stuck portals
killall -9 xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal 2>/dev/null

# Start in correct order with proper paths for Void
/usr/libexec/xdg-desktop-portal-hyprland &
sleep 2
/usr/libexec/xdg-desktop-portal-gtk &
sleep 1
/usr/libexec/xdg-desktop-portal &
