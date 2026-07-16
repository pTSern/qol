local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local config = wezterm.config_builder()

--- Font Options ---
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 13.0

--- Color Scheme ---
config.color_scheme = 'Catppuccin Mocha'

--- Window Styling & Clean Layout ---
config.window_decorations = "NONE"

--- The Unbreakable Transparency Fix ---
-- 1. Explicitly turn off unstable Windows OS-level backdrops
config.win32_system_backdrop = 'Acrylic'

-- 2. Use WezTerm's built-in GPU alpha blend (225 / 255 = ~0.88)
config.window_background_opacity = 0.8

-- 3. Crucial: Tell WezTerm to ignore window focus states when rendering colors
-- This completely deletes the "blinking/flashing" effect when switching apps!
-- config.unfocused_blur = 0

--- Performance & Animations ---
config.animation_fps = 60
config.max_fps = 60

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.6,
}

config.colors = {
  tab_bar = {
    background = '#11111b', -- Blends seamlessly with Catppuccin Mocha
  }
}

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end
  title = wezterm.truncate_right(title, max_width - 4)

  if tab.is_active then
    return {
      { Background = { Color = "#a6e3a1" } }, -- Active Green
      { Foreground = { Color = "#11111b" } },
      { Attribute = { Intensity = "Bold" } },
      { Text = "  " .. title .. "  " },
    }
  else
    return {
      { Background = { Color = "#1e1e2e" } }, -- Dark Slate
      { Foreground = { Color = "#a6adc8" } }, -- Muted
      { Text = "  " .. title .. "  " },
    }
  end
end)

wezterm.on("update-status", function(window, pane)
  local key_table = window:active_key_table()
  local mode_text = " NORMAL "
  local bg_color = "#a6e3a1" -- Green
  local fg_color = "#11111b"

  if key_table == "locked" then
    mode_text = " LOCKED "
    bg_color = "#f38ba8" -- Red
  elseif key_table == "pane" then
    mode_text = " PANE "
    bg_color = "#cdd6f4" -- Lavender
  elseif key_table == "tab" then
    mode_text = " TAB "
    bg_color = "#f9e2af" -- Yellow
  elseif key_table == "resize" then
    mode_text = " RESIZE "
    bg_color = "#f5c2e7" -- Pink
  elseif key_table == "move" then
    mode_text = " MOVE "
    bg_color = "#89b4fa" -- Blue
  elseif key_table == "scroll" or key_table == "copy_mode" then
    mode_text = " SCROLL "
    bg_color = "#fab387" -- Orange
  elseif key_table == "search_mode" then
    mode_text = " SEARCH "
    bg_color = "#f9e2af" -- Yellow
  elseif key_table == "session" then
    mode_text = " SESSION "
    bg_color = "#94e2d5" -- Teal
  elseif key_table == "tmux" then
    mode_text = " TMUX "
    bg_color = "#cba6f7" -- Purple
  elseif pane:get_title():find("Copy Mode") or pane:get_title():find("Search Mode") then
    mode_text = " SCROLL "
    bg_color = "#fab387" -- Orange
  end

  window:set_left_status(wezterm.format({
    { Background = { Color = bg_color } },
    { Foreground = { Color = fg_color } },
    { Attribute = { Intensity = "Bold" } },
    { Text = mode_text },
    -- Add a small separator spacer between the mode block and the first tab
    { Background = { Color = '#11111b' } },
    { Foreground = { Color = '#11111b' } },
    { Text = "  " },
  }))
  window:set_right_status("")
end)

----------------------------------------------------
--- Keybindings ---
----------------------------------------------------

config.disable_default_key_bindings = true

-- Helper to make sure keybindings are not intercepted when in "locked" mode
local function bind(key, mods, action)
  if not action then
    action = mods
    mods = nil
  end
  local binding = { key = key }
  if mods then
    binding.mods = mods
  end
  binding.action = wezterm.action_callback(function(window, pane)
    if window:active_key_table() == 'locked' then
      local send_key_args = { key = key }
      if mods then
        send_key_args.mods = mods
      end
      window:perform_action(act.SendKey(send_key_args), pane)
    else
      window:perform_action(action, pane)
    end
  end)
  return binding
end

config.keys = {
  -- Mode Switchers (Zellij trigger keys)
  bind('g', 'CTRL', act.ActivateKeyTable { name = 'locked', one_shot = false }),
  bind('p', 'CTRL', act.ActivateKeyTable { name = 'pane', one_shot = false }),
  bind('t', 'CTRL', act.ActivateKeyTable { name = 'tab', one_shot = false }),
  bind('n', 'CTRL', act.ActivateKeyTable { name = 'resize', one_shot = false }),
  bind('h', 'CTRL', act.ActivateKeyTable { name = 'move', one_shot = false }),
  bind('s', 'CTRL', act.ActivateCopyMode), -- Translates Scroll/Search to WezTerm Copy/Search Mode
  bind('b', 'CTRL', act.ActivateKeyTable { name = 'tmux', one_shot = false }),
  bind('i', 'CTRL', act.ActivateKeyTable { name = 'session', one_shot = false }),

  -- Shared Global Hotkeys (shared_except "locked")
  bind('LeftArrow', 'ALT', act.ActivatePaneDirection 'Left'),
  bind('DownArrow', 'ALT', act.ActivatePaneDirection 'Down'),
  bind('UpArrow', 'ALT', act.ActivatePaneDirection 'Up'),
  bind('RightArrow', 'ALT', act.ActivatePaneDirection 'Right'),
  bind('h', 'ALT', act.ActivatePaneDirection 'Left'),
  bind('j', 'ALT', act.ActivatePaneDirection 'Down'),
  bind('k', 'ALT', act.ActivatePaneDirection 'Up'),
  bind('l', 'ALT', act.ActivatePaneDirection 'Right'),
  
  bind('+', 'ALT', act.IncreaseFontSize),
  bind('-', 'ALT', act.DecreaseFontSize),
  bind('=', 'ALT', act.ResetFontSize),
  
  bind('i', 'ALT', act.MoveTabRelative(-1)),
  bind('o', 'ALT', act.MoveTabRelative(1)),
  bind('f', 'ALT', act.TogglePaneZoomState),
  bind('n', 'ALT', act.Multiple { act.SplitHorizontal { domain = 'CurrentPaneDomain' }, act.PopKeyTable }),
  bind('q', 'CTRL', act.QuitApplication),
  
  bind('l', 'ALT|SHIFT', act.ActivateTabRelative(1)),
  bind('h', 'ALT|SHIFT', act.ActivateTabRelative(-1)),
  bind('Enter', 'ALT', act.DisableDefaultAssignment),
}

config.key_tables = {
  locked = {
    { key = 'g', mods = 'CTRL', action = act.PopKeyTable },
  },

  pane = {
    { key = 'LeftArrow', action = act.ActivatePaneDirection 'Left' },
    { key = 'DownArrow', action = act.ActivatePaneDirection 'Down' },
    { key = 'UpArrow', action = act.ActivatePaneDirection 'Up' },
    { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
    { key = 'h', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', action = act.ActivatePaneDirection 'Right' },
    
    { key = 'c', action = act.PromptInputLine {
        description = 'Rename Current Pane:',
        action = wezterm.action_callback(function(window, pane, line)
          if line then pane:set_title(line) end
        end),
    } },
    { key = 'd', action = act.Multiple { act.SplitVertical { domain = 'CurrentPaneDomain' }, act.PopKeyTable } },
    { key = 'e', action = act.Multiple { act.TogglePaneZoomState, act.PopKeyTable } },
    { key = 'f', action = act.Multiple { act.TogglePaneZoomState, act.PopKeyTable } },
    { key = 'n', action = act.Multiple { act.SplitHorizontal { domain = 'CurrentPaneDomain' }, act.PopKeyTable } },
    { key = 'p', action = act.ActivatePaneDirection 'Next' },
    { key = 'r', action = act.Multiple { act.SplitHorizontal { domain = 'CurrentPaneDomain' }, act.PopKeyTable } },
    { key = 's', action = act.Multiple { act.SplitHorizontal { domain = 'CurrentPaneDomain' }, act.PopKeyTable } },
    { key = 'x', action = act.Multiple { act.CloseCurrentPane { confirm = false }, act.PopKeyTable } },
    
    { key = 'Escape', action = act.PopKeyTable },
    { key = 'Enter', action = act.PopKeyTable },
    { key = 'p', mods = 'CTRL', action = act.PopKeyTable },
  },

  tab = {
    { key = 'LeftArrow', action = act.ActivateTabRelative(-1) },
    { key = 'DownArrow', action = act.ActivateTabRelative(1) },
    { key = 'UpArrow', action = act.ActivateTabRelative(-1) },
    { key = 'RightArrow', action = act.ActivateTabRelative(1) },
    { key = 'h', action = act.ActivateTabRelative(-1) },
    { key = 'l', action = act.ActivateTabRelative(1) },
    { key = 'j', action = act.ActivateTabRelative(-1) },
    { key = 'k', action = act.ActivateTabRelative(1) },
    
    { key = '1', action = act.Multiple { act.ActivateTab(0), act.PopKeyTable } },
    { key = '2', action = act.Multiple { act.ActivateTab(1), act.PopKeyTable } },
    { key = '3', action = act.Multiple { act.ActivateTab(2), act.PopKeyTable } },
    { key = '4', action = act.Multiple { act.ActivateTab(3), act.PopKeyTable } },
    { key = '5', action = act.Multiple { act.ActivateTab(4), act.PopKeyTable } },
    { key = '6', action = act.Multiple { act.ActivateTab(5), act.PopKeyTable } },
    { key = '7', action = act.Multiple { act.ActivateTab(6), act.PopKeyTable } },
    { key = '8', action = act.Multiple { act.ActivateTab(7), act.PopKeyTable } },
    { key = '9', action = act.Multiple { act.ActivateTab(8), act.PopKeyTable } },
    
    { key = 'b', action = act.Multiple {
        wezterm.action_callback(function(window, pane)
          pane:move_to_new_tab()
        end),
        act.PopKeyTable
    } },
    { key = '[', action = act.Multiple {
        wezterm.action_callback(function(window, pane)
          pane:move_to_new_tab()
        end),
        act.MoveTabRelative(-1),
        act.PopKeyTable
    } },
    { key = ']', action = act.Multiple {
        wezterm.action_callback(function(window, pane)
          pane:move_to_new_tab()
        end),
        act.MoveTabRelative(1),
        act.PopKeyTable
    } },
    { key = 'Tab', action = act.ActivateLastTab },

    { key = 'n', action = act.Multiple { act.SpawnTab 'CurrentPaneDomain', act.PopKeyTable } },
    { key = 'd', action = act.Multiple { act.CloseCurrentTab { confirm = false }, act.PopKeyTable } },
    { key = 'r', action = act.Multiple {
        act.PopKeyTable,
        act.PromptInputLine {
          description = 'Rename Current Tab:',
          action = wezterm.action_callback(function(window, pane, line)
            if line then window:active_tab():set_title(line) end
          end),
        }
    } },
    
    { key = 'Escape', action = act.PopKeyTable },
    { key = 'Enter', action = act.PopKeyTable },
    { key = 't', mods = 'CTRL', action = act.PopKeyTable },
  },

  resize = {
    { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 5 } },
    { key = 'h', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 5 } },
    
    { key = 'H', mods = 'SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },
    { key = 'J', mods = 'SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'K', mods = 'SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'L', mods = 'SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
    
    { key = '+', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = '-', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = '=', action = act.AdjustPaneSize { 'Up', 5 } },
    
    { key = 'Escape', action = act.PopKeyTable },
    { key = 'Enter', action = act.PopKeyTable },
    { key = 'n', mods = 'CTRL', action = act.PopKeyTable },
  },

  move = {
    -- WezTerm rotates panes layout directionally to mimic moving
    { key = 'LeftArrow', action = act.RotatePanes 'CounterClockwise' },
    { key = 'h', action = act.RotatePanes 'CounterClockwise' },
    { key = 'RightArrow', action = act.RotatePanes 'Clockwise' },
    { key = 'l', action = act.RotatePanes 'Clockwise' },
    { key = 'DownArrow', action = act.RotatePanes 'Clockwise' },
    { key = 'j', action = act.RotatePanes 'Clockwise' },
    { key = 'UpArrow', action = act.RotatePanes 'CounterClockwise' },
    { key = 'k', action = act.RotatePanes 'CounterClockwise' },
    
    { key = 'Escape', action = act.PopKeyTable },
    { key = 'Enter', action = act.PopKeyTable },
    { key = 'h', mods = 'CTRL', action = act.PopKeyTable },
  },

  session = {
    { key = 'w', action = act.Multiple { act.ShowLauncherArgs { flags = 'WORKSPACES' }, act.PopKeyTable } },
    { key = 's', action = act.Multiple { act.ShowLauncherArgs { flags = 'TABS' }, act.PopKeyTable } },
    
    { key = 'Escape', action = act.PopKeyTable },
    { key = 'Enter', action = act.PopKeyTable },
    { key = 'i', mods = 'CTRL', action = act.PopKeyTable },
  },

  tmux = {
    { key = 'LeftArrow', action = act.Multiple { act.ActivatePaneDirection 'Left', act.PopKeyTable } },
    { key = 'DownArrow', action = act.Multiple { act.ActivatePaneDirection 'Down', act.PopKeyTable } },
    { key = 'UpArrow', action = act.Multiple { act.ActivatePaneDirection 'Up', act.PopKeyTable } },
    { key = 'RightArrow', action = act.Multiple { act.ActivatePaneDirection 'Right', act.PopKeyTable } },
    { key = 'h', action = act.Multiple { act.ActivatePaneDirection 'Left', act.PopKeyTable } },
    { key = 'j', action = act.Multiple { act.ActivatePaneDirection 'Down', act.PopKeyTable } },
    { key = 'k', action = act.Multiple { act.ActivatePaneDirection 'Up', act.PopKeyTable } },
    { key = 'l', action = act.Multiple { act.ActivatePaneDirection 'Right', act.PopKeyTable } },
    { key = ' ', action = act.RotatePanes 'Clockwise' },
    { key = '"', action = act.Multiple { act.SplitVertical { domain = 'CurrentPaneDomain' }, act.PopKeyTable } },
    { key = '%', action = act.Multiple { act.SplitHorizontal { domain = 'CurrentPaneDomain' }, act.PopKeyTable } },
    { key = ',', action = act.Multiple {
        act.PopKeyTable,
        act.PromptInputLine {
          description = 'Rename Current Tab:',
          action = wezterm.action_callback(function(window, pane, line)
            if line then window:active_tab():set_title(line) end
          end),
        }
    } },
    { key = '[', action = act.Multiple { act.ActivateCopyMode, act.PopKeyTable } },
    { key = 'c', action = act.Multiple { act.SpawnTab 'CurrentPaneDomain', act.PopKeyTable } },
    { key = 'n', action = act.Multiple { act.ActivateTabRelative(1), act.PopKeyTable } },
    { key = 'p', action = act.Multiple { act.ActivateTabRelative(-1), act.PopKeyTable } },
    { key = 'o', action = act.ActivatePaneDirection 'Next' },
    { key = 'z', action = act.Multiple { act.TogglePaneZoomState, act.PopKeyTable } },
    { key = 'x', action = act.Multiple { act.CloseCurrentPane { confirm = false }, act.PopKeyTable } },
    { key = 'd', action = act.Multiple { act.CloseCurrentTab { confirm = false }, act.PopKeyTable } },
    
    { key = 'Escape', action = act.PopKeyTable },
    { key = 'Enter', action = act.PopKeyTable },
    { key = 'b', mods = 'CTRL', action = act.PopKeyTable },
  }
}


--- Startup Window Size (Fullscreen) ---
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  local gui_window = window:gui_window()

  -- Define your window dimensions (Width, Height)
  local width = 1920
  local height = 1040

  -- 1. Set the exact window size first
  gui_window:set_inner_size(width, height)

  -- 2. Fetch the connected screens information from your OS
  local screens = wezterm.gui.screens()
  local target_screen = screens.active or screens.main

  -- 3. Calculate and apply the exact coordinates to center it
  if target_screen then
	local top_right_x = target_screen.x + target_screen.width - width
    -- Y = Screen's top edge
    local top_right_y = target_screen.y
    
    gui_window:set_position(top_right_x, top_right_y)
  end
end)

return config
