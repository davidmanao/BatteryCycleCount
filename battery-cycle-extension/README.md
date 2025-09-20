# Battery Cycle Count GNOME Extension

A simple GNOME Shell extension that displays your laptop battery's cycle count in the top panel.

## Features

- Shows battery cycle count in the top bar
- Updates every 30 seconds
- Minimal and clean design
- Compatible with GNOME Shell 45, 46, and 47

## Prerequisites

Your system must have the battery cycle count information available at:
```
/sys/class/power_supply/BAT0/cycle_count
```

You can test this by running:
```bash
cat /sys/class/power_supply/BAT0/cycle_count
```

## Installation

### Method 1: Manual Installation

1. Copy the extension to your local extensions directory:
```bash
mkdir -p ~/.local/share/gnome-shell/extensions/battery-cycle-count@gnome-shell-extensions.gcampax.github.com
cp -r * ~/.local/share/gnome-shell/extensions/battery-cycle-count@gnome-shell-extensions.gcampax.github.com/
```

2. Restart GNOME Shell:
   - On X11: Press `Alt + F2`, type `r`, and press Enter
   - On Wayland: Log out and log back in

3. Enable the extension:
```bash
gnome-extensions enable battery-cycle-count@gnome-shell-extensions.gcampax.github.com
```

### Method 2: Using the install script

Run the provided install script:
```bash
./install.sh
```

## Usage

Once installed and enabled, you should see "Cycle: XXX" in your top panel, where XXX is your battery's cycle count.

## Troubleshooting

- If you see "Cycle: N/A", the battery cycle count file might not be available on your system
- If you see "Cycle: Error", check the GNOME Shell logs: `journalctl -f -o cat /usr/bin/gnome-shell`
- Make sure your GNOME Shell version is supported (45, 46, or 47)

## Uninstalling

To remove the extension:
```bash
gnome-extensions disable battery-cycle-count@gnome-shell-extensions.gcampax.github.com
rm -rf ~/.local/share/gnome-shell/extensions/battery-cycle-count@gnome-shell-extensions.gcampax.github.com
```

## License

This extension is released under the GPL v3 license.
