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

local function pane_working_dir(pane)
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri and cwd_uri.file_path then
    return cwd_uri.file_path
  end

  return wezterm.home_dir
end

local codex_exec_script = [[
if ! command -v codex >/dev/null 2>&1; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
fi

if ! command -v codex >/dev/null 2>&1; then
  printf 'codex was not found on PATH.\n'
  printf 'Press Enter to close this tab...'
  IFS= read -r _
  exit 127
fi

codex exec --ephemeral --color never --sandbox read-only --cd "$1" -- "$2"
status=$?
printf '\n[codex exited with status %s]\n' "$status"
printf 'Press Enter to close this tab...'
IFS= read -r _
exit "$status"
]]

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
    { key = 'j', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', action = act.ActivatePaneDirection 'Up' },
  },
}

config.keys = {
  -- Toggle Copy Mode via Ctrl+Shift+n (Native system clipboard works automatically!)
  { key = 'N', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },

  -- Ctrl-t, then h/l/b/r navigates and manages tabs.
  { key = 't', mods = 'CTRL', action = act.ActivateKeyTable { name = 'tab_nav', one_shot = true, timeout_milliseconds = 1500 } },

  -- Ctrl-s, then b/e or r lists and renames workspaces.
  { key = 's', mods = 'CTRL', action = act.ActivateKeyTable { name = 'workspace_nav', one_shot = true, timeout_milliseconds = 1500 } },

  -- Ctrl-i prompts for a Codex request and shows the response in a new tab.
  {
    key = 'i',
    mods = 'CTRL',
    action = act.PromptInputLine {
      description = 'Prompt Codex',
      action = wezterm.action_callback(function(window, pane, line)
        if not line or line == '' then
          return
        end

        local cwd = pane_working_dir(pane)
        window:perform_action(
          act.SpawnCommandInNewTab {
            cwd = cwd,
            args = { 'bash', '-lc', codex_exec_script, 'codex-wezterm', cwd, line },
          },
          pane
        )
      end),
    },
  },

  -- Ctrl-w is Vim's window-command prefix; only use it for WezTerm pane
  -- navigation outside Vim.
  {
    key = 'w',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
      if is_vim(pane) then
        window:perform_action(act.SendKey { key = 'w', mods = 'CTRL' }, pane)
      else
        window:perform_action(
          act.ActivateKeyTable { name = 'pane_nav', one_shot = true, timeout_milliseconds = 1500 },
          pane
        )
      end
    end),
  },

  -- Make Alt-arrow word movement work in shells/readline.
  { key = 'LeftArrow', mods = 'ALT', action = act.SendString '\x1bb' },
  { key = 'RightArrow', mods = 'ALT', action = act.SendString '\x1bf' },
}

return config
