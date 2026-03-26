if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
    exec /home/xirtus_void/start-wayland.sh
fi
