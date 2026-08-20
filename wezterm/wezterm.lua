local wezterm = require("wezterm")
local config = wezterm.config_builder()

require("settings").apply(config)
require("keybindings").apply(config)


-- Configure your leader key (recommended to avoid conflicts)
config.leader = { key = "b", mods = "CTRL" }  -- Use Ctrl+a instead of default Ctrl+b

-- Apply wez-tmux plugin with optional configuration
require("plugins.wez-tmux.plugin").apply_to_config(config, {
    -- Optional: Customize tab index base (0-based or 1-based)
    -- tab_and_split_indices_are_zero_based = true
})

return config
