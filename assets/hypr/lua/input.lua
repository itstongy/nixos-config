-- Migrated from conf.d/input.conf; preserve the existing behavior.
hl.config({ input = { kb_layout = "us", kb_options = "compose:caps", repeat_rate = 40, repeat_delay = 600, numlock_by_default = true, follow_mouse = 1, touchpad = { natural_scroll = false, scroll_factor = 0.4 } } })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.window_rule({ name = "input-01", scroll_touchpad = 0.2, match = { class = "com.mitchellh.ghostty" } })
