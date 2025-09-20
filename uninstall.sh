#!/bin/bash
# Uninstaller script for BatteryCycleCount

echo "BatteryCycleCount Uninstaller"
echo "============================"

INSTALL_DIR="$HOME/.local/bin"

# Remove installed files
if [ -f "$INSTALL_DIR/battery_cycle_count.py" ]; then
    rm "$INSTALL_DIR/battery_cycle_count.py"
    echo "✓ Removed battery_cycle_count.py"
fi

if [ -f "$INSTALL_DIR/battery-cycle-count" ]; then
    rm "$INSTALL_DIR/battery-cycle-count"
    echo "✓ Removed battery-cycle-count wrapper"
fi

echo ""
echo "BatteryCycleCount has been uninstalled."
echo ""
echo "Note: You may want to manually remove the PATH entry from ~/.bashrc"
echo "if you no longer need $INSTALL_DIR in your PATH."