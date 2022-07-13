#!/usr/bin/bash

WARNINGTIME=5000

LOW=15
VERYLOW=10
EMPTY=5

notify-send() {
    #Detect the name of the display in use
    local display=":$(ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"

    #Detect the user using such display
    local user=$(who | grep '('$display')' | awk '{print $1}' | head -n 1)

    #Detect the id of the user
    local uid=$(id -u $user)

    sudo -u $user DISPLAY=$display DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus notify-send "$@"
}

read_power_state() {
  if [ -f /tmp/power_state.info ]; then
    echo "$(cat /tmp/power_state.info)"
  else
    echo "undef"
  fi
}

write_power_state() { # first argumet: power state : power_line, good, low, very_low, empty
  echo $1 > /tmp/power_state.info
}

BATTERYCHARGE=$(upower -i $(upower -e | grep 'BAT') | grep percentage | awk '{print $2}' | sed 's#%##')
POWERLINEONLINE=$(upower -i $(upower -e | grep 'line_power') | grep online | awk '{print $2}')


if [ $POWERLINEONLINE != "yes" ]; then
  if (( $BATTERYCHARGE <= $EMPTY )); then
    if [ $(read_power_state) != "empty" ]; then
      write_power_state "empty"
      notify-send -u critical -t $WARNINGTIME -i /usr/local/sbin/battery_empty.svg 'Battery ALMOST EMPTY !!!' 'Battery charge < 5%. Suspending...'
      sleep 5
      systemctl suspend
    fi
  elif (( $BATTERYCHARGE <= $VERYLOW )); then
    if [ $(read_power_state) != "very_low" ]; then
      write_power_state "very_low"
      notify-send -u critical -t $WARNINGTIME -i /usr/local/sbin/battery_verylow.svg 'Battery VERY LOW !!' 'Battery charge < 10%.'
    fi
  elif (( $BATTERYCHARGE <= $LOW )); then
    if [ $(read_power_state) != "low" ]; then
      write_power_state "low"
      notify-send -u critical -t $WARNINGTIME -i /usr/local/sbin/battery_low.svg 'Battery Low !' 'Battery charge < 15%.'
    fi
  else
    if [ $(read_power_state) != "good" ]; then
      write_power_state "good"
    fi
  fi
else
  if [ $(read_power_state) != "power_line" ]; then
    write_power_state "power_line"
  fi
fi
