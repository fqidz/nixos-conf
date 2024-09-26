local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local theme = wezterm.plugin.require('https://github.com/neapsix/wezterm').main
config.colors = theme.colors()

return config
