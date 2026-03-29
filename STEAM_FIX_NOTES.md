# Steam Fixes for Void Linux + Hyprland + Wayland

## Problem Summary

Steam on Void Linux (runit init) with Hyprland (Wayland compositor) had two major issues:
1. **Steam launcher would not open** - SDL/webhelper crash with "Wayland not available"
2. **Games would launch but not appear** - Games would open on different workspaces, invisible to user

## Root Causes

### Issue 1: Wayland SDL Incompatibility in Steam Container
- Steam's Pressure Vessel runtime (strict container) tried to use Wayland directly
- The container couldn't access Wayland socket properly, causing SDL_Init to fail
- Error: `../webhelper/html_chrome.cpp (626) : Assertion Failed: SDL_Init failed: wayland not available`
- This crashed the entire Steam client before UI could load

### Issue 2: Game Window Management
- Games ARE launching and running correctly
- However, they appeared on different workspaces (invisible to user at runtime)
- Hyprland wasn't properly receiving window focus requests
- User had to manually switch workspaces with Super+2 to see the game

## Solutions Implemented

### Solution 1: X11 Backend via Xwayland
Instead of forcing Wayland inside the container, we configured Steam to use X11 via Xwayland:
- Set `SDL_VIDEODRIVER=x11` - Force X11 backend instead of Wayland
- Set `QT_QPA_PLATFORM=xcb` - Qt uses X11 protocol
- Xwayland (already present on system) transparently bridges X11 apps to Wayland
- This provides full compatibility without breaking Hyprland integration

### Solution 2: GPU Driver Exposure
Configured NVIDIA GPU access for Steam's container:
- Set `__GLX_VENDOR_LIBRARY_NAME=nvidia` - Use NVIDIA OpenGL libraries
- Set `LIBVA_DRIVER_NAME=nvidia` - Hardware video decode
- Set `GBM_BACKEND=nvidia-drm` - GPU memory management
- These ensure games can access GPU in the restricted container

### Solution 3: DBus Initialization
Steam's runtime needs proper D-Bus access:
- Started system DBus daemon explicitly before Steam
- Initialized session DBus with proper environment variables
- Set `STEAM_RUNTIME_DISABLE_DBUS_LAUNCH=1` - Prevent Steam from trying to start its own DBus
- Set `DBUS_SYSTEM_BUS_ADDRESS` - Point to system bus socket

### Solution 4: Hyprland Window Focus Management
Added background daemon to monitor and focus game windows:
- Continuously queries Hyprland for new windows via `hyprctl clients -j`
- When a non-Steam window appears, uses `hyprctl dispatch focuswindow` to focus it
- Ensures games appear on current workspace with user focus
- Gracefully cleans up when Steam exits

### Solution 5: Proton Compatibility
For future Windows game support via Proton:
- Set `DXVK_BACKEND=opengl` - Use OpenGL instead of Vulkan for better compatibility
- Set `PROTON_USE_WINED3D11=1` - Use Wine's D3D11 instead of experimental versions
- Ensures DirectX games work reliably

## Environment Variables Set

| Variable | Value | Reason |
|----------|-------|--------|
| `STEAM_RUNTIME_DISABLE_DBUS_LAUNCH` | 1 | Prevent Steam from spawning its own dbus |
| `DBUS_SYSTEM_BUS_ADDRESS` | unix:path=/run/dbus/system_bus_socket | System bus socket path |
| `__GLX_VENDOR_LIBRARY_NAME` | nvidia | Use NVIDIA OpenGL |
| `LIBVA_DRIVER_NAME` | nvidia | NVIDIA video acceleration |
| `GBM_BACKEND` | nvidia-drm | GPU memory via DRM |
| `DXVK_BACKEND` | opengl | OpenGL for DirectX compat |
| `PROTON_USE_WINED3D11` | 1 | Wine D3D11 support |
| `SDL_VIDEODRIVER` | x11 | X11 backend via Xwayland |
| `QT_QPA_PLATFORM` | xcb | X11 protocol for Qt |
| `DISPLAY` | :0 | X11 display server |
| `STEAM_RUNTIME_PREFER_HOST_LIBRARIES` | 1 | Use host libs when possible |

## Files Modified

- `~/.local/bin/steam-fixed` - Main Steam launcher wrapper with all configuration
- `dualsteam.sh` - Controller binding script (unchanged, uses steam-fixed)

## Testing Verification

✅ Steam launcher opens without SDL/Wayland crash  
✅ Steam UI renders properly  
✅ Games launch successfully  
✅ Games appear in current workspace (no Super+2 needed)  
✅ Final Fantasy XV confirmed working  
✅ GPU drivers properly detected  
✅ Network access working (library updates, etc)

## Usage

```bash
~/.local/bin/steam-fixed &
# or via Steam shortcut which calls steam-fixed
```

## Known Limitations

- Games briefly appear on workspace 0 before Hyprland focus manager moves them (~0.5s delay)
- Some games may still have compatibility issues (depends on game-specific requirements)
- Vulkan not directly supported in container (Proton fallback to OpenGL works fine)

## Future Improvements

- Could optimize window focus detection to be faster/more reliable
- Could add per-game environment overrides
- Could document Proton GE or other Proton versions

## References

- Steam Pressure Vessel: Container runtime for games
- Xwayland: X11 compatibility layer for Wayland
- Hyprland: Wayland window manager
- DXVK: Vulkan-based DirectX implementation

