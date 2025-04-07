-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local pane = wezterm.pane

-- This will hold the configuration.
local config = wezterm.config_builder()

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({ args = { "bash", "-c", "fastfetch; exec bash" } })
	-- window:gui_window():maximize()

	-- local mux = wezterm.mux

	-- local win = mux.get_foreground_window()

	-- mux.spawn_tab(win, {args = {"powershell.exe"}})
end)

-- This is where you actually apply your config choices
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true

config.window_decorations = "RESIZE"
config.window_frame = {
	border_left_width = "0cell",
	border_right_width = "0cell",
	border_bottom_height = "0cell",
	border_top_height = "0cell",
	border_left_color = "black",
	border_right_color = "black",
	border_bottom_color = "black",
	border_top_color = "black",
}

-- For example, changing the color scheme:
config.color_scheme = "Sonokai"
config.colors = {
	-- background = '#3b224c',
	-- background = "#181616", -- vague.nvim bg
	background = "#080808", -- almost black
	--background = "#0c0b0f", -- dark purple
	-- background = "#020202", -- dark purple
	-- background = "#17151c", -- brighter purple
	-- background = "#16141a",
	-- background = "#0e0e12", -- bright washed lavendar
	-- background = 'rgba(59, 34, 76, 100%)',
	cursor_border = "#bea3c7",
	-- cursor_fg = "#281733",
	cursor_bg = "#bea3c7",
	-- selection_fg = '#281733',

	tab_bar = {
		background = "#0c0b0f",
		-- background = "rgba(0, 0, 0, 0%)",
		active_tab = {
			bg_color = "#0c0b0f",
			fg_color = "#bea3c7",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#0c0b0f",
			fg_color = "#f8f2f5",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},

		new_tab = {
			-- bg_color = "rgba(59, 34, 76, 50%)",
			bg_color = "#0c0b0f",
			fg_color = "white",
		},
	},
}

-- config.default_prog = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" }

config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 15.0

config.window_background_opacity = 0.9

local wezterm = require("wezterm")

wezterm.on("new_second_window", function(window, pane)
	local current_dir = pane:get_current_working_dir()
	print(current_dir)
	wezterm.mux.spawn_window({
		cwd = current_dir,
	})
end)

-- default domain and dir
config.default_domain = "WSL:Ubuntu"
config.default_cwd = "/home/johnklein"

-- Keybindings
config.keys = {
	-- create a second window
	{ key = "N", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("new_second_window") },
	-- Create a new tab with the Tab key
	{ key = "Tab", mods = "CTRL", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },

	-- Navigate to tab 1 with Alt + 1
	{ key = "1", mods = "ALT", action = wezterm.action({ ActivateTab = 0 }) },

	-- Navigate to tab 2 with Alt + 2
	{ key = "2", mods = "ALT", action = wezterm.action({ ActivateTab = 1 }) },

	-- Navigate to tab 3 with Alt + 3
	{ key = "3", mods = "ALT", action = wezterm.action({ ActivateTab = 2 }) },

	-- Navigate to tab 4 with Alt + 4
	{ key = "4", mods = "ALT", action = wezterm.action({ ActivateTab = 3 }) },

	-- Navigate to tab 5 with Alt + 5
	{ key = "5", mods = "ALT", action = wezterm.action({ ActivateTab = 4 }) },

	-- Navigate to tab 6 with Alt + 6
	{ key = "6", mods = "ALT", action = wezterm.action({ ActivateTab = 5 }) },

	-- Navigate to tab 7 with Alt + 7
	{ key = "7", mods = "ALT", action = wezterm.action({ ActivateTab = 6 }) },

	-- Navigate to tab 8 with Alt + 8
	{ key = "8", mods = "ALT", action = wezterm.action({ ActivateTab = 7 }) },

	-- Navigate to tab 9 with Alt + 9
	{ key = "9", mods = "ALT", action = wezterm.action({ ActivateTab = 8 }) },

	-- Close the current tab with Ctrl + W
	{ key = "w", mods = "CTRL", action = wezterm.action({ CloseCurrentTab = { confirm = false } }) },

	{ key = "V", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },

	{ key = "C", mods = "CTRL", action = wezterm.action({ CopyTo = "Clipboard" }) },

	{
		key = "p",
		mods = "CTRL|ALT",
		action = wezterm.action.Multiple({
			wezterm.action.SpawnCommandInNewTab({
				args = { "powershell.exe" },
				domain = { DomainName = "local" },
				cwd = "C:/dev",
			}),
			wezterm.time.call_after(1, function()
				wezterm.action.CloseCurrentTab({ confirm = false }) -- Close the current tab
			end),
		}),
	},
	-- open side panel
	{
		key = [[\]],
		mods = "CTRL",
		action = wezterm.action.SplitHorizontal({
			domain = "CurrentPaneDomain",
		}),
	},
	-- open horizonal panel
	{
		key = [[-]],
		mods = "CTRL",
		action = wezterm.action({
			SplitVertical = { domain = "CurrentPaneDomain" },
		}),
	},
	-- resize panels
	{
		key = "LeftArrow",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "RightArrow",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "UpArrow",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "LeftArrow",
		mods = "CTRL",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "DownArrow",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	-- switch panels
	{ key = "LeftArrow", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
	-- Move focus to the pane below
	{ key = "DownArrow", mods = "CTRL", action = act.ActivatePaneDirection("Down") },
	-- Move focus to the pane above
	{ key = "UpArrow", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
	-- Move focus to the pane on the right
	{ key = "RightArrow", mods = "CTRL", action = act.ActivatePaneDirection("Right") },
	{ key = "x", mods = "CTRL", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "F11", action = wezterm.action.ToggleFullScreen },
}

-- and finally, return the configuration to wezterm
return config

