#!/usr/bin/env bash
# RPI OS Touchscreen Keyboard Toggle Shortcut
# Cycles Control Centre > Display > On-screen Keyboard:
#   Enabled always -> Enabled if touchscreen found -> Disabled -> Enabled always
# and shows a small, borderless 3-second popup with the new state.

STATE_SIZE="15pt"   # size of the On / Off / Auto text
DETAIL_SIZE="small" # size of the line underneath
TIMEOUT=3           # seconds the popup stays on screen

# popup "<STATE>" "<detail>" "<color>"
popup() {
  pkill -f "yad.*osk-popup" 2>/dev/null   # replace any popup already showing
  yad --title=osk-popup --class=osk-popup \
      --center --undecorated --no-buttons --fixed --on-top --skip-taskbar \
      --no-focus --timeout="$TIMEOUT" --borders=12 --width=1 --height=1 \
      --image=input-keyboard \
      --text="<span size='$STATE_SIZE' weight='bold' foreground='$3'>$1</span>
<span size='$DETAIL_SIZE' foreground='#7a7a7a'>$2</span>" \
      >/dev/null 2>&1 &
}

set_mode() {
  sudo -n raspi-config nonint do_squeekboard "$1" >/dev/null 2>&1 \
    || pkexec raspi-config nonint do_squeekboard "$1" >/dev/null 2>&1
}

# 0 = Enabled always, 1 = Enabled if touchscreen found, 2 = Disabled
case "$(raspi-config nonint get_squeekboard)" in
  0) set_mode S2 && popup "Auto" "Touchscreen Enabled" "#4a7fb5" ;;
  1) set_mode S3 && popup "Off"  "Disabled"            "#c51a4a" ;;
  *) set_mode S1 && popup "On"   "Always Enabled"      "#75a928" ;;
esac
