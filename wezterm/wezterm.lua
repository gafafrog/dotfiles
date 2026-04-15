local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Medium' })
config.font_size = 13.0
config.scrollback_lines = 10000
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = 'NeverPrompt'
config.window_background_opacity = 0.8
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

config.colors = {
  background = '#1a1a2e',
}

config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.5,
}

config.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- Split panes (tmux-style)
  { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER',       action = wezterm.action.SplitVertical   { domain = 'CurrentPaneDomain' } },

  -- Navigate panes (vim-style and arrow keys)
  { key = 'h',          mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left'  },
  { key = 'j',          mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down'  },
  { key = 'k',          mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up'    },
  { key = 'l',          mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'LeftArrow',  mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left'  },
  { key = 'DownArrow',  mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down'  },
  { key = 'UpArrow',    mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up'    },
  { key = 'RightArrow', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },

  -- Resize panes
  { key = 'H', mods = 'LEADER|SHIFT', action = wezterm.action.AdjustPaneSize { 'Left',  5 } },
  { key = 'J', mods = 'LEADER|SHIFT', action = wezterm.action.AdjustPaneSize { 'Down',  5 } },
  { key = 'K', mods = 'LEADER|SHIFT', action = wezterm.action.AdjustPaneSize { 'Up',    5 } },
  { key = 'L', mods = 'LEADER|SHIFT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },

  -- Pass Ctrl+s through to terminal (e.g. save in vim) by pressing Ctrl+s twice
  { key = 's', mods = 'LEADER|CTRL', action = wezterm.action.SendKey { key = 's', mods = 'CTRL' } },
}

return config
