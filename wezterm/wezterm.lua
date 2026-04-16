local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Medium' })
config.font_size = 13.0
config.scrollback_lines = 10000
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = 'NeverPrompt'
config.window_background_opacity = 0.9
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

config.colors = {
  background = '#1a1a2e',
  foreground = '#f0f0f0',
  cursor_bg = '#f0f0f0',
  cursor_fg = '#1a1a2e',
  selection_bg = '#3d3d5c',
  selection_fg = '#ffffff',
}

config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.6,
}

config.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- Pass C-S-arrow through to terminal apps (e.g. Emacs buffer-move)
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = wezterm.action.DisableDefaultAssignment },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.DisableDefaultAssignment },
  { key = 'UpArrow', mods = 'CTRL|SHIFT', action = wezterm.action.DisableDefaultAssignment },
  { key = 'DownArrow', mods = 'CTRL|SHIFT', action = wezterm.action.DisableDefaultAssignment },

  -- Pass Cmd+r through to terminal apps (e.g. Emacs revert-buffer)
  { key = 'r', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },

  -- Split panes (tmux-style)
  { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Navigate panes (vim-style and arrow keys)
  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'LeftArrow', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'DownArrow', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'UpArrow', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'RightArrow', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },

  -- Resize panes
  { key = 'H', mods = 'LEADER|SHIFT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'LEADER|SHIFT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'LEADER|SHIFT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'LEADER|SHIFT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },

  -- Tabs (tmux-style)
  { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = ',', mods = 'LEADER', action = wezterm.action.PromptInputLine {
    description = 'Tab name:',
    action = wezterm.action_callback(function(window, _, line)
      if line then window:active_tab():set_title(line) end
    end),
  }},
  { key = 'n', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) },

  -- Swap panes
  { key = '{', mods = 'LEADER|SHIFT', action = wezterm.action.PaneSelect { mode = 'SwapWithActive' } },

  -- Pass Ctrl+s through to terminal (e.g. save in vim) by pressing Ctrl+s twice
  { key = 's', mods = 'LEADER|CTRL', action = wezterm.action.SendKey { key = 's', mods = 'CTRL' } },
}

return config
