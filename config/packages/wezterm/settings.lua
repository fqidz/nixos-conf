local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.colors = wezterm.plugin.require('https://github.com/neapsix/wezterm').main

return config
