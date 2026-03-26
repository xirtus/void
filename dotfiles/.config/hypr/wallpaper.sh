#!/bin/bash

# Wait for the environment to settle
sleep 3

WALLPAPER_DIR="/home/xirtus_void/Pictures/Wallpapers"
mkdir -p "$WALLPAPER_DIR"
INTERVAL=3600   # 60 minutes

while true; do
    # === 5 different safe 6-tag presets ===
    PRESET1="

    # Randomly pick one
    CHOSEN_PRESET=$((RANDOM % 5 + 1))
    case $CHOSEN_PRESET in
        1) TAGS="$PRESET1" ;;
        2) TAGS="$PRESET2" ;;
        3) TAGS="$PRESET3" ;;
        4) TAGS="$PRESET4" ;;
        5) TAGS="$PRESET5" ;;
    esac

    API_URL="https://konachan.com/post.json?tags=$(echo $TAGS | sed 's/ /+/g')&limit=100"

    RESPONSE=$(curl -s --max-time 15 "$API_URL")

    # Better parsing: check if it's a real array of posts
    IMAGE_URL=$(echo "$RESPONSE" | jq -r 'if type=="array" then .[].file_url else empty end' | shuf -n 1 2>/dev/null)

    if [ -n "$IMAGE_URL" ] && [ "$IMAGE_URL" != "null" ] && [ "$IMAGE_URL" != "" ]; then
        FILE_NAME=$(basename "$IMAGE_URL")
        WALLPAPER_PATH="$WALLPAPER_DIR/$FILE_NAME"

        echo "[$(date '+%H:%M:%S')] Downloading (Preset $CHOSEN_PRESET) → $FILE_NAME"
        curl -s -L -o "$WALLPAPER_PATH" "$IMAGE_URL"

        killall swaybg 2>/dev/null
        swaybg -i "$WALLPAPER_PATH" -m fill &

        ln -sf "$WALLPAPER_PATH" "$WALLPAPER_DIR/current_wallpaper.jpg"

        echo "[$(date '+%H:%M:%S')] ✓ Wallpaper changed successfully"
    else
        echo "[$(date '+%H:%M:%S')] API error or no results. Using fallback wallpaper"
        killall swaybg 2>/dev/null
        swaybg -i /home/xirtus_void/void_wall.png -m fill &
    fi

    sleep $INTERVAL
done
