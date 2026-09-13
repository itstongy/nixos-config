-- Migrated from conf.d/windows.conf; preserve the existing behavior.
-- Ignore application maximize requests and keep common utility windows tiled.
hl.window_rule({ name = "windows-01", suppress_event = "maximize", match = { class = ".*" } })
-- Steam menus are separate untitled windows; only force the main window tiled.
hl.window_rule({ name = "windows-02", tile = true, match = { class = "^(steam|Steam)$", title = "^Steam$" } })
hl.window_rule({ name = "steam-popup", float = true, match = { class = "^(steam|Steam)$", title = "^$" } })
hl.window_rule({ name = "windows-03", tile = true, match = { class = "org.tongy.btop" } })
-- Keep video playback fully opaque despite the global window transparency.
hl.window_rule({ name = "windows-04", opacity = "1.0 override 1.0 override", match = { class = "^(mpv)$" } })
-- Keep the Bitwarden desktop app and detached browser-extension window floating
-- in the center. (The browser's anchored toolbar panel is not a separate window.)
hl.window_rule({ name = "windows-05", float = true, match = { class = "^(Bitwarden)$" } })
hl.window_rule({ name = "windows-06", center = true, match = { class = "^(Bitwarden)$" } })
hl.window_rule({ name = "windows-07", float = true, match = { title = "^(Bitwarden|Bitwarden Password Manager)$" } })
hl.window_rule({ name = "windows-08", center = true, match = { title = "^(Bitwarden|Bitwarden Password Manager)$" } })
-- Center the path-aware file palette as a lightweight desktop popup.
-- Float only the radar player; its Ghostty launcher remains tiled.
-- Keep the display awake while Zen presents fullscreen media.
hl.window_rule({ name = "windows-16", idle_inhibit = "fullscreen", match = { class = "^(zen)$" } })
-- Avoid focusing broken transient XWayland surfaces.
hl.window_rule({ name = "fix-xwayland-drag", match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, no_focus = true })
hl.window_rule({ name = "windows-18", float = true, match = { title = "^(Picture-in-Picture)$" } })
-- Caelestia-styled privilege prompt.
hl.window_rule({ name = "windows-19", float = true, match = { title = "^(Authentication Required)$" } })
hl.window_rule({ name = "windows-20", center = true, match = { title = "^(Authentication Required)$" } })
hl.window_rule({ name = "windows-21", stay_focused = true, match = { title = "^(Authentication Required)$" } })

-- Utility-window behavior carried over from Niri.
hl.window_rule({ name = "niri-steam-friends", match = { class = "^(steam|Steam)$", title = "^Friends List$" }, float = true, size = "480 900" })
hl.window_rule({ name = "niri-bitwarden-extension", match = { class = "^zen$", title = "^Extension: [(]Bitwarden Password Manager[)].*" }, float = true, center = true, size = "520 720" })
hl.window_rule({ name = "niri-chatgpt-opacity", match = { class = "^(chatgpt|ChatGPT)$" }, opacity = "0.92 override 0.92 override" })

-- Last rule wins; removing the tag restores each window's normal opacity.
hl.window_rule({
    name = "temporary-opaque",
    match = { tag = "temporary-opaque" },
    opacity = "1.0 override 1.0 override 1.0 override",
    opaque = true,
    force_rgbx = true
})
