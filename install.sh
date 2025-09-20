#!/bin/bash
# Simple installer script for BatteryCycleCount
# For ThinkPad 14s Gen 3 on Ubuntu (Wayland compatible)

set -e

echo "BatteryCycleCount Installer"
echo "=========================="

# Check if running on Ubuntu
if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    if [ "$DISTRIB_ID" = "Ubuntu" ]; then
        echo "✓ Ubuntu detected"
    else
        echo "⚠ This installer is optimized for Ubuntu"
    fi
fi

# Check if running on Wayland
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "✓ Wayland session detected"
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    echo "✓ X11 session detected (script will work on both X11 and Wayland)"
else
    echo "ℹ Display server type not detected, but script should work regardless"
fi

# Create installation directory
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# Copy the main script
echo "Installing battery_cycle_count.py to $INSTALL_DIR..."
cp battery_cycle_count.py "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/battery_cycle_count.py"

# Create a simple wrapper script
cat > "$INSTALL_DIR/battery-cycle-count" << 'EOF'
#!/bin/bash
exec python3 "$HOME/.local/bin/battery_cycle_count.py" "$@"
EOF
chmod +x "$INSTALL_DIR/battery-cycle-count"

# Add to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Adding $INSTALL_DIR to PATH..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo "Please run 'source ~/.bashrc' or start a new terminal session"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Usage:"
echo "  battery-cycle-count              # Show cycle count"
echo "  battery-cycle-count --verbose    # Show detailed info"
echo "  battery-cycle-count --check-system  # Check system compatibility"
echo ""
echo "Or run directly:"
echo "  python3 $INSTALL_DIR/battery_cycle_count.py"
echo ""

# Try to install recommended packages
echo "Checking for recommended packages..."

if command -v apt-get >/dev/null 2>&1; then
    echo "Would you like to install recommended packages for better battery monitoring? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "Installing acpi and upower packages..."
        sudo apt-get update
        sudo apt-get install -y acpi upower
        
        # For ThinkPad specific monitoring
        echo "Would you like to install ThinkPad-specific battery monitoring (tp-smapi-dkms)? (y/N)"
        read -r tp_response
        if [[ "$tp_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            sudo apt-get install -y tp-smapi-dkms
        fi
    fi
fi

echo ""
echo "🔋 BatteryCycleCount is now installed and ready to use!"