#!/bin/bash

# Test script to verify battery cycle count availability

echo "Testing battery cycle count availability..."
echo ""

BATTERY_PATH="/sys/class/power_supply/BAT0/cycle_count"

if [ -f "$BATTERY_PATH" ]; then
    CYCLE_COUNT=$(cat "$BATTERY_PATH")
    echo "✓ Battery cycle count file found: $BATTERY_PATH"
    echo "✓ Current cycle count: $CYCLE_COUNT"
    echo ""
    echo "Your GNOME extension should display: Cycle: $CYCLE_COUNT"
else
    echo "✗ Battery cycle count file not found: $BATTERY_PATH"
    echo ""
    echo "Alternative battery paths to check:"
    for bat in /sys/class/power_supply/BAT*; do
        if [ -d "$bat" ]; then
            echo "  - $bat/"
            if [ -f "$bat/cycle_count" ]; then
                echo "    ✓ cycle_count: $(cat $bat/cycle_count)"
            else
                echo "    ✗ cycle_count: not available"
            fi
        fi
    done
fi

echo ""
echo "Other battery information:"
if [ -f "/sys/class/power_supply/BAT0/capacity" ]; then
    echo "  Current charge: $(cat /sys/class/power_supply/BAT0/capacity)%"
fi
if [ -f "/sys/class/power_supply/BAT0/status" ]; then
    echo "  Status: $(cat /sys/class/power_supply/BAT0/status)"
fi
