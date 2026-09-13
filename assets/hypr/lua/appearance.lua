-- Frosted glass: broad blur, restrained transparency, and soft edges.
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 12,
        border_size = 2,
        col = {
            active_border = "rgb(7fbbb3)",
            inactive_border = "rgba(475258aa)"
        },
        resize_on_border = true,
        layout = "dwindle"
    },
    decoration = {
        rounding = 16,
        rounding_power = 4.0,
        active_opacity = 0.88,
        inactive_opacity = 0.84,
        fullscreen_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 24,
            render_power = 3,
            color = "rgba(10182055)"
        },
        blur = {
            enabled = true,
            size = 8,
            passes = 3,
            vibrancy = 0.24,
            noise = 0.008,
            contrast = 0.95,
            brightness = 1.04,
            popups = true
        }
    },
    animations = {
        enabled = true
    },
    dwindle = {
        preserve_split = true
    },
    group = {
        col = {
            border_active = "rgb(7fbbb3)",
            border_locked_active = "rgb(83c092)"
        }
    },
    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0
    }
})
-- Compositor-enforced glass for apps without native transparency.
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 3.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.4, bezier = "quick", style = "slidefadevert 20%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slidevert" })
