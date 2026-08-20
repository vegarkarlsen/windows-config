local wezterm = require("wezterm")

local M = {}

function M.apply(config)

    -- PowerShell
    config.default_prog = { "pwsh.exe", "-NoLogo" }

    -- Theme
    config.color_scheme = "Tokyo Night"

    -- Window
    -- config.window_decorations = "RESIZE"
    config.window_background_opacity = 0.9

    -- config.window_padding = {
    --   left = 1,
    --   right = 1,
    --   top = 1,
    --   bottom = 1,
    -- }

    -- Font
    config.font = wezterm.font("MesloLGS NF")
    config.font_size = 11.0

    -- Selection
    -- config.selection_word_boundary = " \t\n{}[]()\"'`,;:"
    --config.copy_on_select = true

    -- Bell
    config.audible_bell = "Disabled" end

return M
