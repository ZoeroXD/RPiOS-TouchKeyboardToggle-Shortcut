#!/usr/bin/env bash
# Installer for RPI OS Touchscreen Keyboard Toggle Shortcut
set -e
SRC="$(cd "$(dirname "$0")" && pwd)"
NOPASS=0
[ "$1" = "--no-password" ] && NOPASS=1

echo "==> Installing dependencies (yad, squeekboard)"
sudo apt-get update -qq
sudo apt-get install -y yad squeekboard

echo "==> Installing script to ~/bin/toggle-osk.sh"
mkdir -p "$HOME/bin"
install -m 755 "$SRC/toggle-osk.sh" "$HOME/bin/toggle-osk.sh"

echo "==> Creating desktop and menu shortcut"
DESK=$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")
mkdir -p "$DESK" "$HOME/.local/share/applications"
sed "s|@SCRIPT@|$HOME/bin/toggle-osk.sh|" "$SRC/toggle-keyboard.desktop" > "$DESK/toggle-keyboard.desktop"
chmod +x "$DESK/toggle-keyboard.desktop"
cp "$DESK/toggle-keyboard.desktop" "$HOME/.local/share/applications/"
gio set "$DESK/toggle-keyboard.desktop" metadata::trusted true 2>/dev/null || true

echo "==> Adding labwc window rule (borderless popup)"
python3 - <<'PY'
import os, re
p = os.path.expanduser("~/.config/labwc/rc.xml")
rule = ('<windowRule title="osk-popup" serverDecoration="no">'
        '<skipTaskbar>yes</skipTaskbar><skipWindowSwitcher>yes</skipWindowSwitcher>'
        '</windowRule>')
os.makedirs(os.path.dirname(p), exist_ok=True)
s = open(p).read() if os.path.exists(p) else '<?xml version="1.0"?>\n<labwc_config>\n</labwc_config>\n'
if 'title="osk-popup"' not in s:
    if os.path.exists(p): open(p + ".bak", "w").write(s)
    if "</windowRules>" in s:
        s = s.replace("</windowRules>", "  " + rule + "\n</windowRules>", 1)
    else:
        s = re.sub(r"(</(?:labwc|openbox)_config>)", "<windowRules>\n  " + rule + "\n</windowRules>\n\\1", s, count=1)
    open(p, "w").write(s)
PY
labwc --reconfigure 2>/dev/null || true

if [ "$NOPASS" = 1 ]; then
  echo "==> Allowing raspi-config without a password for $USER"
  echo "$USER ALL=(root) NOPASSWD: /usr/bin/raspi-config" | sudo tee /etc/sudoers.d/osk-toggle >/dev/null
  sudo chmod 440 /etc/sudoers.d/osk-toggle
fi

echo "Done. Tap 'Toggle Keyboard' on the desktop."
