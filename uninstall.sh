#!/usr/bin/env bash
# Removes RPI OS Touchscreen Keyboard Toggle Shortcut (keeps your keyboard setting as-is)
DESK=$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")
rm -f "$HOME/bin/toggle-osk.sh" "$DESK/toggle-keyboard.desktop" \
      "$HOME/.local/share/applications/toggle-keyboard.desktop"
[ -f "$HOME/.config/labwc/rc.xml" ] && sed -i '/title="osk-popup"/d' "$HOME/.config/labwc/rc.xml"
sudo rm -f /etc/sudoers.d/osk-toggle
labwc --reconfigure 2>/dev/null || true
echo "Removed."
