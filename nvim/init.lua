vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

vim.o.relativenumber = true
vim.o.number = true

vim.o.autoread = true

vim.keymap.set("n", "<F5>", function()
    -- Get the current working directory in WSL
    local cwd = vim.fn.getcwd()
    -- Convert it to a Windows path
    local win_cwd = vim.fn.system("wslpath -w " .. cwd):gsub("\n", "")

    -- Define the example name
    local example_name = "example"

    -- Windows PowerShell command
    local cmd = string.format(
        [[wsl.exe powershell.exe -NoExit -Command "& { Set-Location '%s'; cargo watch -x 'run --example %s' }"]],
        win_cwd, example_name
    )

    
    -- Run the command in a new tmux window
    vim.fn.system(string.format("tmux new-window -d '%s'", cmd))
end, { noremap = true, silent = true })

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
