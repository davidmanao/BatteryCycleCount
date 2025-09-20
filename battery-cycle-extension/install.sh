#!/bin/bash

# Battery Cycle Count GNOME Extension Installer

set -e

EXTENSION_UUID="battery-cycle-count@gnome-shell-extensions.gcampax.github.com"
EXTENSION_DIR="$HOME/.local/share/gnome-shell/extensions/$EXTENSION_UUID"

echo "Installing Battery Cycle Count GNOME Extension..."

# Check if battery cycle count is available
if [ ! -f /sys/class/power_supply/BAT0/cycle_count ]; then
    echo "Warning: /sys/class/power_supply/BAT0/cycle_count not found."
    echo "This extension may not work on your system."
    read -p "Do you want to continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 1
    fi
fi

# Create extension directory
mkdir -p "$EXTENSION_DIR"

# Copy extension files
echo "Copying extension files..."
cp extension.js "$EXTENSION_DIR/"
cp metadata.json "$EXTENSION_DIR/"
cp stylesheet.css "$EXTENSION_DIR/"

echo "Extension files copied to: $EXTENSION_DIR"

# Check if gnome-extensions command is available
if command -v gnome-extensions >/dev/null 2>&1; then
    echo "Enabling extension..."
    gnome-extensions enable "$EXTENSION_UUID"
    echo "Extension enabled successfully!"
else
    echo "gnome-extensions command not found."
    echo "Please restart GNOME Shell and enable the extension manually:"
    echo "- On X11: Press Alt+F2, type 'r', and press Enter"
    echo "- On Wayland: Log out and log back in"
    echo "- Then enable the extension using GNOME Extensions app or:"
    echo "  gnome-extensions enable $EXTENSION_UUID"
fi

echo ""
echo "Installation complete!"
echo "You should see 'Cycle: XXX' in your top panel."
echo ""
echo "If you don't see it, try restarting GNOME Shell:"
echo "- On X11: Alt+F2, type 'r', press Enter"
echo "- On Wayland: Log out and log back in"
