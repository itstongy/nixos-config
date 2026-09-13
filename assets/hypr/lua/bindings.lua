
-- Launcher and applications
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("vicinae toggle"), { description = "Vicinae launcher" })
hl.bind("SUPER + R", hl.dsp.global("caelestia:launcher"), { description = "Caelestia launcher" })
hl.bind("SUPER + C", hl.dsp.exec_cmd("hypr-copy-paste copy"), { description = "Copy" })
hl.bind("SUPER + V", hl.dsp.exec_cmd("hypr-copy-paste paste"), { description = "Paste" })
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("caelestia clipboard"), { description = "Clipboard history" })
hl.bind("SUPER + SHIFT + SPACE", hl.dsp.global("caelestia:showall"), { description = "Toggle Caelestia panels" })
hl.bind("SUPER + B", hl.dsp.global("caelestia:sidebar"), { description = "Caelestia sidebar" })
hl.bind("SUPER + SHIFT + ESCAPE", hl.dsp.global("caelestia:session"), { description = "Session menu" })
hl.bind("SUPER + CTRL + ALT + L", hl.dsp.global("caelestia:lock"), { description = "Lock screen" })
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("uwsm-app -- ghostty"), { description = "Terminal" })
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd("hypr-open-or-focus org.tongy.tmux --legacy-app-id com.mitchellh.ghostty --legacy-title-regex '^tmux$' -- ghostty --class=org.tongy.tmux -e tmux new-session -A -s main"), { description = "Tmux" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("hypr-open-or-focus org.gnome.Nautilus --title-regex '^Documents$' -- nautilus --new-window $HOME/Documents"), { description = "Documents" })
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("hypr-open-or-focus org.gnome.Nautilus --title-regex '^Downloads$' -- nautilus --new-window $HOME/Downloads"), { description = "Downloads" })
hl.bind("SUPER + SHIFT + SLASH", hl.dsp.exec_cmd("hypr-open-or-focus Bitwarden -- bitwarden"), { description = "Passwords" })
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("hypr-open-or-focus org.tongy.btop -- ghostty --class=org.tongy.btop -e btop"), { description = "Activity" })
hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd("hypr-open-or-focus org.tongy.btop -- ghostty --class=org.tongy.btop -e btop"), { description = "Activity" })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("hypr-open-or-focus org.tongy.nvim -- ghostty --class=org.tongy.nvim -e nvim"), { description = "Editor" })
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd("hypr-open-or-focus md.obsidian.Obsidian -- obsidian"), { description = "Obsidian" })
hl.bind("SUPER + SHIFT + bracketleft", hl.dsp.exec_cmd("uwsm-app -- zathura"), { description = "PDF viewer" })

-- Screenshots (saved to Pictures/Screenshots and copied to the clipboard)
hl.bind("PRINT", hl.dsp.exec_cmd("take-screenshot full"), { description = "Full-screen screenshot" })
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("take-screenshot region"), { description = "Region screenshot" })
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("ocr-screenshot"), { description = "OCR region to clipboard" })

-- Browser, ChatGPT app, and web shortcuts
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("hypr-open-or-focus zen-beta --legacy-app-id zen -- zen-beta --name zen-beta"), { description = "Browser" })
hl.bind("SUPER + SHIFT + BACKSLASH", hl.dsp.exec_cmd("uwsm-app -- zen-beta --name zen-beta https://claude.ai"), { description = "Claude" })
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("uwsm-app -- zen-beta --name zen-beta https://calendar.google.com"), { description = "Calendar" })
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("uwsm-app -- zen-beta --name zen-beta https://gmail.com"), { description = "Email" })
hl.bind("SUPER + SHIFT + Y", hl.dsp.exec_cmd("hypr-open-or-focus org.tongy.yazi -- ghostty --class=org.tongy.yazi -e yazi $HOME/Documents"), { description = "Yazi Documents" })
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("uwsm-app -- zen-beta --name zen-beta https://messenger.com"), { description = "Messenger" })

-- Window control
hl.bind("SUPER + Y", hl.dsp.window.tag({ tag = "temporary-opaque" }), { description = "Toggle window transparency" })
hl.bind("SUPER + W", hl.dsp.window.close(), { description = "Close window" })
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Full screen" })
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "set" }), { description = "Tiled full screen" })
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Full width" })
hl.bind("SUPER + ALT + J", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind("SUPER + P", hl.dsp.window.pseudo(), { description = "Pseudo window" })
hl.bind("SUPER + G", hl.dsp.group.toggle(), { description = "Toggle group" })
hl.bind("SUPER + ALT + G", hl.dsp.window.move({ out_of_group = true }), { description = "Leave group" })

-- Focus and swap windows
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }), { description = "Focus left" })
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }), { description = "Focus down" })
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }), { description = "Focus up" })
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }), { description = "Focus right" })
hl.bind("SUPER + LEFT", hl.dsp.focus({ direction = "left" }), { description = "Focus left" })
hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "right" }), { description = "Focus right" })
hl.bind("SUPER + UP", hl.dsp.focus({ direction = "up" }), { description = "Focus up" })
hl.bind("SUPER + DOWN", hl.dsp.focus({ direction = "down" }), { description = "Focus down" })
hl.bind("SUPER + SHIFT + H", hl.dsp.window.swap({ direction = "left" }), { description = "Swap left" })
hl.bind("SUPER + SHIFT + J", hl.dsp.window.swap({ direction = "down" }), { description = "Swap down" })
hl.bind("SUPER + SHIFT + K", hl.dsp.window.swap({ direction = "up" }), { description = "Swap up" })
hl.bind("SUPER + SHIFT + L", hl.dsp.window.swap({ direction = "right" }), { description = "Swap right" })
hl.bind("SUPER + SHIFT + LEFT", hl.dsp.window.swap({ direction = "left" }), { description = "Swap left" })
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.swap({ direction = "right" }), { description = "Swap right" })
hl.bind("SUPER + SHIFT + UP", hl.dsp.window.swap({ direction = "up" }), { description = "Swap up" })
hl.bind("SUPER + SHIFT + DOWN", hl.dsp.window.swap({ direction = "down" }), { description = "Swap down" })

-- Workspace navigation
hl.bind("SUPER + TAB", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind("SUPER + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind("SUPER + CTRL + TAB", hl.dsp.focus({ workspace = "previous" }), { description = "Former workspace" })
hl.bind("CTRL + ALT + TAB", hl.dsp.focus({ monitor = "+1" }), { description = "Next monitor" })
hl.bind("CTRL + ALT + SHIFT + TAB", hl.dsp.focus({ monitor = "-1" }), { description = "Previous monitor" })
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("scratchpad"), { description = "Toggle scratchpad" })
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }), { description = "Move to scratchpad" })

-- Number-row workspace bindings (physical key codes retain behavior across layouts)
hl.bind("SUPER + code:10", hl.dsp.focus({ workspace = "1" }), { description = "Workspace 1" })
hl.bind("SUPER + code:11", hl.dsp.focus({ workspace = "2" }), { description = "Workspace 2" })
hl.bind("SUPER + code:12", hl.dsp.focus({ workspace = "3" }), { description = "Workspace 3" })
hl.bind("SUPER + code:13", hl.dsp.focus({ workspace = "4" }), { description = "Workspace 4" })
hl.bind("SUPER + code:14", hl.dsp.focus({ workspace = "5" }), { description = "Workspace 5" })
hl.bind("SUPER + code:15", hl.dsp.focus({ workspace = "6" }), { description = "Workspace 6" })
hl.bind("SUPER + code:16", hl.dsp.focus({ workspace = "7" }), { description = "Workspace 7" })
hl.bind("SUPER + code:17", hl.dsp.focus({ workspace = "8" }), { description = "Workspace 8" })
hl.bind("SUPER + code:18", hl.dsp.focus({ workspace = "9" }), { description = "Workspace 9" })
hl.bind("SUPER + code:19", hl.dsp.focus({ workspace = "10" }), { description = "Workspace 10" })
hl.bind("SUPER + SHIFT + code:10", hl.dsp.window.move({ workspace = "1", follow = true }), { description = "Move to workspace 1" })
hl.bind("SUPER + SHIFT + code:11", hl.dsp.window.move({ workspace = "2", follow = true }), { description = "Move to workspace 2" })
hl.bind("SUPER + SHIFT + code:12", hl.dsp.window.move({ workspace = "3", follow = true }), { description = "Move to workspace 3" })
hl.bind("SUPER + SHIFT + code:13", hl.dsp.window.move({ workspace = "4", follow = true }), { description = "Move to workspace 4" })
hl.bind("SUPER + SHIFT + code:14", hl.dsp.window.move({ workspace = "5", follow = true }), { description = "Move to workspace 5" })
hl.bind("SUPER + SHIFT + code:15", hl.dsp.window.move({ workspace = "6", follow = true }), { description = "Move to workspace 6" })
hl.bind("SUPER + SHIFT + code:16", hl.dsp.window.move({ workspace = "7", follow = true }), { description = "Move to workspace 7" })
hl.bind("SUPER + SHIFT + code:17", hl.dsp.window.move({ workspace = "8", follow = true }), { description = "Move to workspace 8" })
hl.bind("SUPER + SHIFT + code:18", hl.dsp.window.move({ workspace = "9", follow = true }), { description = "Move to workspace 9" })
hl.bind("SUPER + SHIFT + code:19", hl.dsp.window.move({ workspace = "10", follow = true }), { description = "Move to workspace 10" })

-- Mouse move/resize; Super+wheel intentionally remains unbound.
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { description = "Resize window" })

-- Audio and media controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("CTRL + SUPER + equal", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("CTRL + SUPER + minus", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("CTRL + SUPER + backslash", hl.dsp.exec_cmd("hypr-open-or-focus org.tongy.wiremix -- ghostty --class=org.tongy.wiremix -e wiremix"), { description = "Audio controls" })

-- These work automatically once playerctl is installed.
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("CTRL + SUPER + bracketleft", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("CTRL + SUPER + bracketright", hl.dsp.exec_cmd("playerctl next"))
hl.bind("CTRL + SUPER + apostrophe", hl.dsp.exec_cmd("playerctl play-pause"))

-- Preserve the Discord deafen key forwarded by external hardware/macros.
hl.bind("F24", hl.dsp.send_shortcut({ mods = "CTRL_SHIFT", key = "D", window = "class:^(discord)$" }))

-- Toggle the session's default layout; config reload returns to dwindle.
hl.bind("SUPER + CTRL + S", function()
    local current = hl.get_config("general:layout")
    local next_layout = current == "scrolling" and "dwindle" or "scrolling"
    hl.config({ general = { layout = next_layout } })
    local label = next_layout == "scrolling" and "Scrolling" or "Dwindle"
    hl.exec_cmd('notify-send -a Hyprland -i /usr/share/icons/Papirus/48x48/apps/preferences-desktop-display.svg -t 2000 "Layout switched" "' .. label .. '"')
end, { description = "Toggle scrolling / dwindle layout" })

-- Resize by a fraction of the active window; the Lua dispatcher takes pixels.
local function resize_fraction(dx, dy)
    return function()
        local window = hl.get_active_window()
        if not window then return end
        hl.dispatch(hl.dsp.window.resize({
            x = window.size.x * dx,
            y = window.size.y * dy,
            relative = true,
        }))
    end
end

-- Shortcuts carried over from Niri.
hl.bind("SUPER + ESCAPE", hl.dsp.global("caelestia:lock"), { description = "Lock screen", dont_inhibit = true })
hl.bind("SUPER + COMMA", resize_fraction(-0.1, 0), { description = "Narrow window", repeating = true })
hl.bind("SUPER + PERIOD", resize_fraction(0.1, 0), { description = "Widen window", repeating = true })
hl.bind("SUPER + SHIFT + COMMA", resize_fraction(0, -0.1), { description = "Shorten window", repeating = true })
hl.bind("SUPER + SHIFT + PERIOD", resize_fraction(0, 0.1), { description = "Taller window", repeating = true })
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("hypr-open-or-focus chatgpt -- chatgpt"), { description = "ChatGPT" })


hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd("nm-connection-editor"), { description = "Network controls" })
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd("hypr-open-or-focus org.tongy.bluetui -- ghostty --class=org.tongy.bluetui -e bluetui"), { description = "Bluetooth controls" })
