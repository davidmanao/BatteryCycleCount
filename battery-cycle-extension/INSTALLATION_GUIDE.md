# Battery Cycle Count GNOME Extension - Installation Guide

## What This Extension Does

This GNOME Shell extension displays your laptop battery's cycle count directly in the top panel. It reads the cycle count from `/sys/class/power_supply/BAT0/cycle_count` and updates every 30 seconds.

## Files Created

- `extension.js` - Main extension code
- `metadata.json` - Extension metadata
- `stylesheet.css` - Styling for the extension
- `install.sh` - Installation script
- `uninstall.sh` - Uninstallation script
- `test-battery.sh` - Test script to verify battery information
- `README.md` - Detailed documentation

## Quick Installation

1. **Run the install script:**
   ```bash
   ./install.sh
   ```

2. **Restart GNOME Shell:**
   - On X11 (most common): Press `Alt + F2`, type `r`, and press Enter
   - On Wayland: Log out and log back in

3. **Enable the extension (if not auto-enabled):**
   ```bash
   gnome-extensions enable battery-cycle-count@gnome-shell-extensions.gcampax.github.com
   ```

## Verification

After installation and restart, you should see "Cycle: 18" (or your actual cycle count) in the top panel.

You can run the test script to verify everything is working:
```bash
./test-battery.sh
```

## Manual Installation (Alternative)

If the install script doesn't work, you can install manually:

```bash
# Create extension directory
mkdir -p ~/.local/share/gnome-shell/extensions/battery-cycle-count@gnome-shell-extensions.gcampax.github.com

# Copy files
cp extension.js metadata.json stylesheet.css ~/.local/share/gnome-shell/extensions/battery-cycle-count@gnome-shell-extensions.gcampax.github.com/

# Restart GNOME Shell and enable
gnome-extensions enable battery-cycle-count@gnome-shell-extensions.gcampax.github.com
```

## Troubleshooting

1. **Extension not visible after restart:**
   - Check if it's enabled: `gnome-extensions list --enabled | grep battery`
   - Check GNOME Shell logs: `journalctl -f -o cat /usr/bin/gnome-shell`

2. **Shows "Cycle: N/A" or "Cycle: Error":**
   - Verify battery file exists: `cat /sys/class/power_supply/BAT0/cycle_count`
   - Check file permissions

3. **Extension won't enable:**
   - Check GNOME Shell version compatibility
   - Verify all files are in the correct directory
   - Restart GNOME Shell again

## Uninstalling

Run the uninstall script:
```bash
./uninstall.sh
```

Or manually:
```bash
gnome-extensions disable battery-cycle-count@gnome-shell-extensions.gcampax.github.com
rm -rf ~/.local/share/gnome-shell/extensions/battery-cycle-count@gnome-shell-extensions.gcampax.github.com
```

## Current System Status

Your system shows:
- Battery cycle count: 18
- Current charge: 95%
- Status: Not charging
- Battery file location: /sys/class/power_supply/BAT0/cycle_count ✓

The extension should work perfectly on your system!
