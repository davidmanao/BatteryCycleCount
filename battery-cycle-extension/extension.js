import St from 'gi://St';
import GLib from 'gi://GLib';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

let label, timeout;

function updateBatteryCount() {
    try {
        let [success, contents] = GLib.file_get_contents('/sys/class/power_supply/BAT0/cycle_count');
        if (success) {
            const cycleCount = new TextDecoder().decode(contents).trim();
            label.set_text(`Bat:${cycleCount}`);
        } else {
            label.set_text('Bat:N/A');
        }
    } catch (e) {
        label.set_text('Bat:Err');
    }
    return GLib.SOURCE_CONTINUE;
}

export default class Extension {
    enable() {
        label = new St.Label({
            text: 'Bat:18',
            style_class: 'panel-button',
            y_align: 2,  // Middle align
            style: 'font-size: 11px; margin: 0; padding: 0 6px;'
        });
        
        Main.panel._leftBox.add_child(label);
        
        // Update immediately and then every 30 seconds
        updateBatteryCount();
        timeout = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 30, updateBatteryCount);
    }
    
    disable() {
        if (timeout) {
            GLib.Source.remove(timeout);
            timeout = null;
        }
        if (label) {
            Main.panel._leftBox.remove_child(label);
            label.destroy();
            label = null;
        }
    }
}
