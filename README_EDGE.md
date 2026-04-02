# Void Linux Edge: The Most Cutting Edge Versions
This branch of void-packages tracks the absolute latest stable and verified updates for system-critical components, including Vulkan, Mesa, and modern compilers.

## Current Edge Status:
| Package | Version | Status |
| :--- | :--- | :--- |
| **vulkan-loader** | 1.4.341.0 | Stable/Verified |
| **mesa** | 25.3.3_1 | Stable/Verified |
| **glslang** | 16.2.0_1 | Stable/Verified |
| **shaderc** | 2026.1_1 | Stable/Verified |

## For Hardware: Alienware x17 R1 (Tiger Lake)
This branch includes specific optimizations for the Intel UHD TGL GT1 and NVIDIA RTX 3070 Mobile.

## Usage:
1. Clone this branch: `git clone -b edge-bleeding https://github.com/xirtus/void`
2. Build as usual with `./xbps-src pkg <package>`
