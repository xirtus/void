#!/bin/bash

# Define your tracked projects: "Display Name|Local Directory|Update & Build Command"
# Git fetch checks for updates, git rebase reapplies your local patches on top of the new code.
TRACKED_REPOS=(
    "Bottles|$HOME/src/bottles|git fetch origin && git rebase origin/main && ninja -C build install"
    "Systemd-efault|$HOME/src/Systemd-efault|git fetch origin && git rebase origin/main && make && sudo make install"
    "Openclaw|$HOME/src/openclaw|git fetch origin && git rebase origin/master && make clean && make"
)

UPDATE_LIST=""

# Check each repo for upstream changes
for REPO in "${TRACKED_REPOS[@]}"; do
    NAME="${REPO%%|*}"
    PATH_CMD="${REPO#*|}"
    DIR="${PATH_CMD%%|*}"

    cd "$DIR" || continue

    # Silently fetch upstream without modifying working directory
    git fetch origin > /dev/null 2>&1

    # Check if local branch is behind origin
    BEHIND=$(git rev-list HEAD..@{u} --count 2>/dev/null)

    if [[ "$BEHIND" -gt 0 ]]; then
        UPDATE_LIST+="$NAME ($BEHIND commits behind)\n"
    fi
done

# If no updates, exit cleanly
if [[ -z "$UPDATE_LIST" ]]; then
    notify-send "Source Updater" "All tracked GitHub repositories are up to date."
    exit 0
fi

# Pipe the list of available updates into Fuzzel
CHOICE=$(echo -e "$UPDATE_LIST" | fuzzel --dmenu --prompt="Updates Available: ")

# If the user pressed ESC or closed Fuzzel
if [[ -z "$CHOICE" ]]; then
    exit 0
fi

# Extract the selected name and execute the corresponding build command
SELECTED_NAME=$(echo "$CHOICE" | sed 's/ (.*//')

for REPO in "${TRACKED_REPOS[@]}"; do
    NAME="${REPO%%|*}"
    if [[ "$NAME" == "$SELECTED_NAME" ]]; then
        PATH_CMD="${REPO#*|}"
        DIR="${PATH_CMD%%|*}"
        CMD="${PATH_CMD#*|}"

        # Open a terminal window to run the update so you can watch the compiler/rebase output
        # (Replace 'alacritty' with your preferred terminal emulator)
        alacritty -e bash -c "cd '$DIR' && echo 'Executing: $CMD' && eval '$CMD'; echo 'Press Enter to exit.'; read"
        break
    fi
done
