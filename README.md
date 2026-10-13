# RPI OS Touchscreen Keyboard Toggle Shortcut

A one-tap desktop shortcut for Raspberry Pi OS (labwc / Wayland) that cycles the built-in **Squeekboard** on-screen keyboard through the same three modes found in **Control Centre → Display → On-screen Keyboard**, and shows a small, borderless popup with the new state.

```
On (Enabled always)  →  Auto (Enabled if touchscreen found)  →  Off (Disabled)  →  On ...
```

| State | Popup | Control Centre equivalent |
|---|---|---|
| **On** (green) | Always Enabled | Enabled always |
| **Auto** (blue) | Touchscreen Enabled | Enabled if touchscreen found |
| **Off** (red) | Disabled | Disabled |

It uses the same command Control Centre and `raspi-config` use (`raspi-config nonint do_squeekboard S1|S2|S3`), so the result is identical to changing the setting by hand.

## Requirements

- Raspberry Pi OS Bookworm or Trixie with the default **labwc** desktop
- `yad` and `squeekboard` (installed automatically)

## Install

```bash
git clone https://github.com/ZoeroXD/RPI-OS-Touchscreen-Keyboard-Toggle-Shortcut.git
cd RPI-OS-Touchscreen-Keyboard-Toggle-Shortcut
./install.sh
```

If a password box appears every time you tap the shortcut, reinstall with:

```bash
./install.sh --no-password
```

This adds `/etc/sudoers.d/osk-toggle`, allowing your user to run `raspi-config` without a password.

## What the installer does

1. Installs `yad` and `squeekboard`
2. Copies `toggle-osk.sh` to `~/bin/`
3. Creates a **Toggle Keyboard** icon on the desktop and in the app menu
4. Adds a labwc window rule to `~/.config/labwc/rc.xml` so the popup has no title bar (a backup is saved as `rc.xml.bak`)

## Customize

Edit the top of `~/bin/toggle-osk.sh`:

```bash
STATE_SIZE="15pt"   # size of the On / Off / Auto text
DETAIL_SIZE="small" # size of the line underneath
TIMEOUT=3           # seconds the popup stays on screen
```

Colors use Raspberry Pi brand green `#75a928` and red `#c51a4a`. Change them in the `case` block at the bottom of the script.

## Check the current mode

```bash
raspi-config nonint get_squeekboard   # 0 = On, 1 = Auto, 2 = Off
```

## Uninstall

```bash
./uninstall.sh
```

Your current keyboard setting is left as it is.

## Troubleshooting

- **Title bar still shows on the popup:** log out and back in so labwc reloads its config.
- **Mode doesn't change:** run `sudo raspi-config nonint do_squeekboard S1; echo $?` and check for errors.
- **No popup:** run `yad --text=test` to confirm `yad` works.

## License

MIT
