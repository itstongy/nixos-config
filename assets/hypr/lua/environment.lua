-- Migrated from conf.d/environment.conf; preserve the existing behavior.
-- Bibata is an XCursor theme; use it in the compositor as well as apps.
hl.config({ cursor = { enable_hyprcursor = false } })
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("MOZ_ENABLE_WAYLAND", "1")
