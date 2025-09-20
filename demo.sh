#!/bin/bash
# Demo script showing BatteryCycleCount usage examples
# This simulates what users would see on a real ThinkPad 14s Gen 3

echo "BatteryCycleCount Demo"
echo "====================="
echo ""
echo "This demo shows how BatteryCycleCount would work on a real ThinkPad 14s Gen 3"
echo "running Ubuntu with Wayland."
echo ""

echo "1. Basic Usage:"
echo "$ battery-cycle-count"
echo ""
echo "Expected output on ThinkPad 14s Gen 3:"
cat << 'EOF'
BatteryCycleCount - ThinkPad Battery Monitor
=============================================
✓ ThinkPad system detected
✓ ThinkPad 14s Gen 3 detected - this tool is optimized for your system
Reading battery information from: /sys/class/power_supply/BAT0
Battery cycle count: 127

🔋 Battery Cycle Count: 127
✓ Battery is in excellent condition
EOF

echo ""
echo "2. Verbose Mode:"
echo "$ battery-cycle-count --verbose"
echo ""
echo "Expected output:"
cat << 'EOF'
BatteryCycleCount - ThinkPad Battery Monitor
=============================================
✓ ThinkPad system detected
✓ ThinkPad 14s Gen 3 detected - this tool is optimized for your system
Reading battery information from: /sys/class/power_supply/BAT0
Battery cycle count: 127

=== System Information ===
Sys Vendor: LENOVO
Product Name: 21CK000HUS
Product Version: ThinkPad 14s Gen 3

=== Detailed Battery Information ===
Cycle Count: 127
Manufacturer: LGC
Model Name: 02DL020
Serial Number: 5B10W13933
Technology: Li-ion
Voltage Now: 12456000
Voltage Max Design: 12600000
Charge Full: 4521000
Charge Full Design: 4730000
Capacity: 95
Status: Not charging
Present: 1
Battery Health: 95.6%

🔋 Battery Cycle Count: 127
✓ Battery is in excellent condition
EOF

echo ""
echo "3. System Check:"
echo "$ battery-cycle-count --check-system"
echo ""
echo "Expected output:"
cat << 'EOF'
BatteryCycleCount - ThinkPad Battery Monitor
=============================================

=== System Information ===
Sys Vendor: LENOVO
Product Name: 21CK000HUS
Product Version: ThinkPad 14s Gen 3
✓ ThinkPad system detected
✓ ThinkPad 14s Gen 3 detected - this tool is optimized for your system

Reading battery information from: /sys/class/power_supply/BAT0
Battery cycle count: 127

🔋 Battery Cycle Count: 127
✓ Battery is in excellent condition
EOF

echo ""
echo "4. Installation:"
echo "$ git clone https://github.com/davidmanao/BatteryCycleCount.git"
echo "$ cd BatteryCycleCount"
echo "$ ./install.sh"
echo ""

echo "5. Wayland Compatibility:"
echo "The tool works identically on both Wayland and X11 since it only"
echo "reads system files and doesn't require any GUI components."
echo ""

echo "6. Troubleshooting on Real Hardware:"
echo "If cycle count is not available, the tool suggests:"
echo "- Installing 'acpi' and 'upower' packages"
echo "- Installing 'tp-smapi-dkms' for ThinkPad-specific features"
echo "- Running with sudo if permission issues occur"
echo ""

echo "For more information, see the README.md file."