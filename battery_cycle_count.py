#!/usr/bin/env python3
"""
BatteryCycleCount - A tool to read battery cycle count on ThinkPad laptops
Supports ThinkPad 14s Gen 3 on Ubuntu with Wayland compatibility
"""

import os
import sys
import glob
import argparse
import subprocess
from pathlib import Path


class BatteryCycleCount:
    """Battery cycle count reader for ThinkPad laptops"""
    
    def __init__(self):
        self.battery_paths = []
        self.cycle_count = None
        self.battery_info = {}
    
    def find_battery_paths(self):
        """Find all available battery paths in the system"""
        # Primary path for most modern Linux systems
        power_supply_paths = glob.glob('/sys/class/power_supply/BAT*')
        
        # Alternative paths for ThinkPad laptops
        thinkpad_paths = glob.glob('/sys/devices/platform/smapi/BAT*/cycle_count')
        
        # ACPI battery paths
        acpi_paths = glob.glob('/sys/devices/LNXSYSTM:*/LNXSYBUS:*/PNP0A08:*/device:*/PNP0C0A:*/power_supply/BAT*')
        
        all_paths = power_supply_paths + [os.path.dirname(p) for p in thinkpad_paths] + acpi_paths
        
        # Filter to only include actual battery directories
        for path in all_paths:
            if os.path.isdir(path):
                type_file = os.path.join(path, 'type')
                if os.path.exists(type_file):
                    try:
                        with open(type_file, 'r') as f:
                            if f.read().strip() == 'Battery':
                                self.battery_paths.append(path)
                    except (IOError, OSError):
                        continue
        
        return self.battery_paths
    
    def read_battery_info(self, battery_path):
        """Read battery information from a given path"""
        info = {}
        
        # List of files to read for battery information
        files_to_read = [
            'cycle_count', 'manufacturer', 'model_name', 'serial_number',
            'technology', 'voltage_now', 'voltage_max_design',
            'charge_full', 'charge_full_design', 'capacity',
            'status', 'health', 'present'
        ]
        
        for filename in files_to_read:
            filepath = os.path.join(battery_path, filename)
            if os.path.exists(filepath):
                try:
                    with open(filepath, 'r') as f:
                        info[filename] = f.read().strip()
                except (IOError, OSError) as e:
                    info[filename] = f"Error reading: {e}"
        
        return info
    
    def get_cycle_count_from_acpi(self):
        """Try to get cycle count using acpi command as fallback"""
        try:
            # Try using acpi command if available
            result = subprocess.run(['acpi', '-b'], capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                return result.stdout.strip()
        except (subprocess.SubprocessError, FileNotFoundError):
            pass
        
        try:
            # Try using upower as another fallback
            result = subprocess.run(['upower', '-i', '/org/freedesktop/UPower/devices/battery_BAT0'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                for line in result.stdout.split('\n'):
                    if 'cycle-count' in line.lower():
                        return line.strip()
        except (subprocess.SubprocessError, FileNotFoundError):
            pass
        
        return None
    
    def get_cycle_count(self):
        """Get battery cycle count using various methods"""
        self.find_battery_paths()
        
        if not self.battery_paths:
            print("No battery found in the system.")
            fallback_info = self.get_cycle_count_from_acpi()
            if fallback_info:
                print(f"Fallback information: {fallback_info}")
            return None
        
        for battery_path in self.battery_paths:
            print(f"Reading battery information from: {battery_path}")
            self.battery_info = self.read_battery_info(battery_path)
            
            # Try to get cycle count
            if 'cycle_count' in self.battery_info:
                try:
                    self.cycle_count = int(self.battery_info['cycle_count'])
                    print(f"Battery cycle count: {self.cycle_count}")
                    return self.cycle_count
                except ValueError:
                    print(f"Could not parse cycle count: {self.battery_info['cycle_count']}")
            else:
                print("Cycle count not available in this battery path.")
        
        # Try fallback methods
        print("Trying fallback methods...")
        fallback_info = self.get_cycle_count_from_acpi()
        if fallback_info:
            print(f"Fallback information: {fallback_info}")
        
        return None
    
    def print_detailed_info(self):
        """Print detailed battery information"""
        if not self.battery_info:
            print("No battery information available.")
            return
        
        print("\n=== Detailed Battery Information ===")
        for key, value in self.battery_info.items():
            formatted_key = key.replace('_', ' ').title()
            print(f"{formatted_key}: {value}")
        
        # Calculate some additional metrics if possible
        if 'charge_full' in self.battery_info and 'charge_full_design' in self.battery_info:
            try:
                full_charge = int(self.battery_info['charge_full'])
                design_charge = int(self.battery_info['charge_full_design'])
                health_percentage = (full_charge / design_charge) * 100
                print(f"Battery Health: {health_percentage:.1f}%")
            except (ValueError, ZeroDivisionError):
                pass
    
    def check_thinkpad_compatibility(self):
        """Check if the system is a ThinkPad and provide specific information"""
        dmi_files = [
            '/sys/class/dmi/id/sys_vendor',
            '/sys/class/dmi/id/product_name',
            '/sys/class/dmi/id/product_version'
        ]
        
        system_info = {}
        for dmi_file in dmi_files:
            if os.path.exists(dmi_file):
                try:
                    with open(dmi_file, 'r') as f:
                        key = os.path.basename(dmi_file)
                        system_info[key] = f.read().strip()
                except (IOError, OSError):
                    pass
        
        if system_info:
            print("\n=== System Information ===")
            for key, value in system_info.items():
                formatted_key = key.replace('_', ' ').title()
                print(f"{formatted_key}: {value}")
            
            # Check if it's a ThinkPad
            vendor = system_info.get('sys_vendor', '').lower()
            product = system_info.get('product_name', '').lower()
            
            if 'lenovo' in vendor and 'thinkpad' in product:
                print("✓ ThinkPad system detected")
                if '14s gen 3' in product:
                    print("✓ ThinkPad 14s Gen 3 detected - this tool is optimized for your system")
                return True
            else:
                print("⚠ This tool is optimized for ThinkPad laptops")
        
        return False


def main():
    """Main function to run the battery cycle count tool"""
    parser = argparse.ArgumentParser(
        description='BatteryCycleCount - Read battery cycle count on ThinkPad laptops',
        epilog='This tool is optimized for ThinkPad 14s Gen 3 on Ubuntu with Wayland support'
    )
    parser.add_argument('-v', '--verbose', action='store_true',
                       help='Show detailed battery information')
    parser.add_argument('--check-system', action='store_true',
                       help='Check system compatibility')
    
    args = parser.parse_args()
    
    print("BatteryCycleCount - ThinkPad Battery Monitor")
    print("=" * 45)
    
    battery_monitor = BatteryCycleCount()
    
    if args.check_system:
        battery_monitor.check_thinkpad_compatibility()
        print()
    
    cycle_count = battery_monitor.get_cycle_count()
    
    if args.verbose:
        battery_monitor.print_detailed_info()
    
    if cycle_count is not None:
        print(f"\n🔋 Battery Cycle Count: {cycle_count}")
        
        # Provide guidance based on cycle count
        if cycle_count < 300:
            print("✓ Battery is in excellent condition")
        elif cycle_count < 500:
            print("✓ Battery is in good condition")
        elif cycle_count < 1000:
            print("⚠ Battery is showing moderate wear")
        else:
            print("⚠ Battery may need replacement soon")
    else:
        print("❌ Could not determine battery cycle count")
        print("\nTroubleshooting tips:")
        print("1. Make sure you're running this on a laptop with a battery")
        print("2. Try running with sudo if you get permission errors")
        print("3. Check if 'acpi' or 'upower' packages are installed")
        print("4. For ThinkPad laptops, consider installing 'tp-smapi-dkms'")
        return 1
    
    return 0


if __name__ == '__main__':
    sys.exit(main())