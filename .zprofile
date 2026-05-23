if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
    exec /home/xirtus_void/start-wayland.sh
fi


# Added by Antigravity CLI installer
export PATH="/home/xirtus_void/.local/bin:$PATH"
