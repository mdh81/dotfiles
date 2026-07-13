local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- ====================================================================
-- 🎨 VISUALS, FONTS, AND COLOR SCHEME
-- ====================================================================

-- 1. Typography (Safely falls back to icons/emojis if missing)
config.font = wezterm.font_with_fallback({
  { family = 'Monaco' , weight = 'Bold' },
  { family = 'Symbols Nerd Font Mono' },
})
config.font_size = 15

-- 2. Theme Selection (Built directly into WezTerm)
config.color_scheme = 'Monokai Remastered'

-- 3. Window Layout Aesthetic
config.window_background_opacity = 0.95        -- Sleek transparency
config.macos_window_background_blur = 20       -- Beautiful macOS blurred frost look
config.window_decorations = "RESIZE"           -- Removes ugly native title bar buttons
config.window_padding = {                      -- Generous breathing room
  left = 12,
  right = 12,
  top = 12,
  bottom = 12,
}

-- 4. Clean Custom Tab Bar Design
config.use_dead_keys = false
config.enable_tab_bar = true
config.use_fancy_tab_bar = false               -- Clean flat tabs instead of fat blocks
config.tab_bar_at_bottom = true                -- Tabs at the bottom like tmux status line

-- ====================================================================
-- 🧠 VIM PROCESS PASSTHROUGH LOGIC
-- ====================================================================

-- Helper: Detect if the active pane is running Vim
local function is_vim(pane)
  local process_name = pane:get_foreground_process_name()
  if process_name == nil then return false end
  return process_name:match("n?vim") ~= nil
end

-- ====================================================================
-- ⌨️ MODAL KEY TABLES & SHORTCUTS
-- ====================================================================

config.key_tables = {
  tab_nav = {
    { key = 'h', action = act.ActivateTabRelative(-1) },
    { key = 'l', action = act.ActivateTabRelative(1) },
    { key = 'b', action = act.ActivateKeyTable { name = 'buffer_nav', one_shot = true, timeout_milliseconds = 1500 } },
    {
      key = 'r',
      action = act.PromptInputLine {
        description = 'Enter new name for tab',
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },
	{ key = 'n', action = act.SpawnTab 'CurrentPaneDomain' },
  },

  buffer_nav = {
    { key = 'e', action = act.ShowLauncherArgs { flags = 'TABS' } },
  },

  workspace_nav = {
    { key = 'b', action = act.ActivateKeyTable { name = 'workspace_buffer_nav', one_shot = true, timeout_milliseconds = 1500 } },
    {
      key = 'r',
      action = act.PromptInputLine {
        description = 'Enter new name for workspace',
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
          end
        end),
      },
    },
  },

  workspace_buffer_nav = {
    { key = 'e', action = act.ShowLauncherArgs { flags = 'WORKSPACES' } },
  },

  pane_nav = {
    { key = 'n', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'v', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'w', action = act.ActivatePaneDirection 'Next' },
  },
}

config.keys = {
  -- Toggle Copy Mode via Ctrl+Shift+n (Native system clipboard works automatically!)
  { key = 'N', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },

  -- Ctrl-t, then h/l/b/r navigates and manages tabs.
  { key = 't', mods = 'CTRL', action = act.ActivateKeyTable { name = 'tab_nav', one_shot = true, timeout_milliseconds = 1500 } },

  -- Ctrl-s, then b/e or r lists and renames workspaces.
  { key = 's', mods = 'CTRL', action = act.ActivateKeyTable { name = 'workspace_nav', one_shot = true, timeout_milliseconds = 1500 } },

  -- Ctrl-w, then n/v/w creates and cycles panes.
  { key = 'w', mods = 'CTRL', action = act.ActivateKeyTable { name = 'pane_nav', one_shot = true, timeout_milliseconds = 1500 } },

  -- Make Alt-arrow word movement work in shells/readline.
  { key = 'LeftArrow', mods = 'ALT', action = act.SendString '\x1bb' },
  { key = 'RightArrow', mods = 'ALT', action = act.SendString '\x1bf' },
}

return config
