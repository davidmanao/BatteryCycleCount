#!/bin/bash

# Battery Cycle Count GNOME Extension Uninstaller

EXTENSION_UUID="battery-cycle-count@gnome-shell-extensions.gcampax.github.com"
EXTENSION_DIR="$HOME/.local/share/gnome-shell/extensions/$EXTENSION_UUID"

echo "Uninstalling Battery Cycle Count GNOME Extension..."

# Disable the extension if gnome-extensions command is available
if command -v gnome-extensions >/dev/null 2>&1; then
    echo "Disabling extension..."
    gnome-extensions disable "$EXTENSION_UUID" 2>/dev/null || echo "Extension was already disabled or not found."
fi

# Remove extension directory
if [ -d "$EXTENSION_DIR" ]; then
    echo "Removing extension files from: $EXTENSION_DIR"
    rm -rf "$EXTENSION_DIR"
    echo "Extension files removed successfully!"
else
    echo "Extension directory not found: $EXTENSION_DIR"
    echo "Extension may not be installed."
fi

echo ""
echo "Uninstallation complete!"
echo "You may need to restart GNOME Shell to see the changes:"
echo "- On X11: Alt+F2, type 'r', press Enter"
echo "- On Wayland: Log out and log back in"
