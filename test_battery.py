#!/usr/bin/env python3
"""
Test script for BatteryCycleCount
Creates mock battery files for testing purposes
"""

import os
import tempfile
import sys
import subprocess
from pathlib import Path

def create_mock_battery_structure():
    """Create a mock battery structure for testing"""
    # Create temporary directory
    temp_dir = tempfile.mkdtemp(prefix="battery_test_")
    
    # Create mock battery directory
    bat0_path = os.path.join(temp_dir, "BAT0")
    os.makedirs(bat0_path)
    
    # Create mock battery files
    battery_files = {
        'type': 'Battery',
        'cycle_count': '127',
        'manufacturer': 'LGC',
        'model_name': '02DL020',
        'serial_number': '12345',
        'technology': 'Li-ion',
        'voltage_now': '12500000',
        'voltage_max_design': '12600000',
        'charge_full': '4500000',
        'charge_full_design': '4730000',
        'capacity': '95',
        'status': 'Not charging',
        'present': '1'
    }
    
    for filename, content in battery_files.items():
        with open(os.path.join(bat0_path, filename), 'w') as f:
            f.write(content)
    
    return temp_dir, bat0_path

def test_battery_script_with_mock_data():
    """Test the battery script with mock data"""
    print("Creating mock battery structure...")
    temp_dir, bat0_path = create_mock_battery_structure()
    
    try:
        print(f"Mock battery created at: {bat0_path}")
        
        # Modify the script temporarily to use our mock path
        script_path = "/home/runner/work/BatteryCycleCount/BatteryCycleCount/battery_cycle_count.py"
        
        # Read the original script
        with open(script_path, 'r') as f:
            original_content = f.read()
        
        # Create a modified version that uses our mock path
        modified_content = original_content.replace(
            "glob.glob('/sys/class/power_supply/BAT*')",
            f"['{bat0_path}']"
        )
        
        # Write the modified script to a temporary file
        test_script_path = os.path.join(temp_dir, "test_battery_cycle_count.py")
        with open(test_script_path, 'w') as f:
            f.write(modified_content)
        
        os.chmod(test_script_path, 0o755)
        
        print("\nTesting basic functionality...")
        result = subprocess.run([sys.executable, test_script_path], 
                              capture_output=True, text=True)
        print("STDOUT:")
        print(result.stdout)
        if result.stderr:
            print("STDERR:")
            print(result.stderr)
        
        print("\nTesting verbose mode...")
        result = subprocess.run([sys.executable, test_script_path, '--verbose'], 
                              capture_output=True, text=True)
        print("STDOUT:")
        print(result.stdout)
        
        print("\nTesting system check...")
        result = subprocess.run([sys.executable, test_script_path, '--check-system'], 
                              capture_output=True, text=True)
        print("STDOUT:")
        print(result.stdout)
        
    finally:
        # Cleanup
        import shutil
        shutil.rmtree(temp_dir)
        print(f"\nCleaned up temporary directory: {temp_dir}")

def test_original_script():
    """Test the original script (will show no battery found message)"""
    print("\n" + "="*50)
    print("Testing original script without mock data...")
    print("="*50)
    
    script_path = "/home/runner/work/BatteryCycleCount/BatteryCycleCount/battery_cycle_count.py"
    
    print("\nBasic test:")
    result = subprocess.run([sys.executable, script_path], 
                          capture_output=True, text=True)
    print("STDOUT:")
    print(result.stdout)
    print(f"Exit code: {result.returncode}")

if __name__ == '__main__':
    print("BatteryCycleCount Test Suite")
    print("="*40)
    
    # Test with mock data
    test_battery_script_with_mock_data()
    
    # Test original script
    test_original_script()
    
    print("\n✅ All tests completed!")