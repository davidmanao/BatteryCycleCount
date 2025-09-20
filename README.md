# BatteryCycleCount

A lightweight Python tool to monitor battery cycle count on ThinkPad laptops, specifically optimized for **ThinkPad 14s Gen 3** running **Ubuntu with Wayland** support.

## Features

- 🔋 Read battery cycle count from multiple system sources
- 🖥️ Full Ubuntu Wayland compatibility (also works on X11)
- 💻 Optimized for ThinkPad laptops, especially 14s Gen 3
- 📊 Detailed battery health information
- 🛠️ Multiple fallback methods for maximum compatibility
- 🚀 Easy installation and usage

## Quick Start

### Installation

1. Clone this repository:
```bash
git clone https://github.com/davidmanao/BatteryCycleCount.git
cd BatteryCycleCount
```

2. Run the installer (recommended):
```bash
./install.sh
```

3. Or run directly:
```bash
python3 battery_cycle_count.py
```

### Usage

```bash
# Basic usage - show cycle count
battery-cycle-count

# Show detailed battery information
battery-cycle-count --verbose

# Check system compatibility
battery-cycle-count --check-system

# Get help
battery-cycle-count --help
```

## Compatibility

### Tested Systems
- ✅ ThinkPad 14s Gen 3 on Ubuntu 22.04 LTS (Wayland)
- ✅ ThinkPad 14s Gen 3 on Ubuntu 22.04 LTS (X11)
- ✅ General ThinkPad models on Ubuntu
- ✅ Most Linux distributions with standard battery interfaces

### Requirements
- Python 3.6+
- Linux with `/sys/class/power_supply/` interface
- Optional: `acpi`, `upower`, `tp-smapi-dkms` packages for enhanced functionality

## How It Works

The tool uses multiple methods to detect and read battery information:

1. **Primary Method**: Reads from `/sys/class/power_supply/BAT*/cycle_count`
2. **ThinkPad Specific**: Checks `/sys/devices/platform/smapi/BAT*/cycle_count`
3. **ACPI Interface**: Uses ACPI battery paths
4. **Fallback Methods**: `acpi` command and `upower` utility

## Sample Output

```
BatteryCycleCount - ThinkPad Battery Monitor
=============================================
✓ ThinkPad system detected
✓ ThinkPad 14s Gen 3 detected - this tool is optimized for your system
Reading battery information from: /sys/class/power_supply/BAT0
Battery cycle count: 127

🔋 Battery Cycle Count: 127
✓ Battery is in excellent condition
```

With `--verbose` flag:
```
=== System Information ===
Sys Vendor: LENOVO
Product Name: 21CK000HUS
Product Version: ThinkPad 14s Gen 3

=== Detailed Battery Information ===
Cycle Count: 127
Manufacturer: LGC
Model Name: 02DL020
Technology: Li-ion
Status: Not charging
Capacity: 95
Battery Health: 95.2%
```

## Troubleshooting

### No Battery Found
- Ensure you're running on a laptop with a battery
- Try running with `sudo` if you get permission errors
- Install recommended packages: `sudo apt install acpi upower`

### ThinkPad Specific Issues
- Install ThinkPad SMAPI: `sudo apt install tp-smapi-dkms`
- Reboot after installing tp-smapi-dkms
- Check if battery is properly seated

### Wayland Compatibility
This tool works identically on both Wayland and X11 as it only reads system files and doesn't require GUI components.

## Battery Health Guidelines

- **0-300 cycles**: Excellent condition
- **300-500 cycles**: Good condition  
- **500-1000 cycles**: Moderate wear
- **1000+ cycles**: Consider replacement

## Development

### Project Structure
```
BatteryCycleCount/
├── battery_cycle_count.py    # Main script
├── install.sh               # Installation script
└── README.md                # Documentation
```

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on ThinkPad hardware if possible
5. Submit a pull request

## License

This project is open source. Feel free to use, modify, and distribute.

## Support

For issues specific to ThinkPad 14s Gen 3 or Ubuntu Wayland, please open an issue with:
- System information (`battery-cycle-count --check-system`)
- Error messages
- Ubuntu version and desktop environment details