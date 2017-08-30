#
# Auto start daemon script that will listen D-bus ScreenSaver event of your desktop environment and start and stop a service
#
INTERFACE_TO_LISTEN=$(dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames | grep -o '[^"]*.ScreenSaver' | tail -1)
UNIT_TO_START=$1
echo "Listen for $INTERFACE_TO_LISTEN event on D-bus for starting $UNIT_TO_START" 1>&2
# Ensure ethminer is stop
systemctl --user stop $UNIT_TO_START
# Listening for ScreenSaver Event on D-bus
dbus-monitor "type='signal',interface='${INTERFACE_TO_LISTEN}',member='ActiveChanged'" \
| while read -r line; do
    #ignore the metadata and pull the 'boolean <true/false>' line
    read line
    if echo $line | grep -q 'true';
    then
      echo "Locked at $(date)" 1>&2
      systemctl --user start $UNIT_TO_START
    fi
    if echo $line | grep -q 'false';
    then
      echo "Unlocked at $(date)" 1>&2
      systemctl --user stop $UNIT_TO_START
    fi
done
