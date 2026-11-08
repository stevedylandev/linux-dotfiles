require('vis')

								-- config --

-- global
vis.events.subscribe(vis.events.INIT, function()
	vis:command("set theme darkmatter")
end)
-- per-window
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command("set tabwidth 2")
	vis:command("set numbers true") vis:command("set autoindent true")
	vis:command("set showspaces false")
	vis:command("set showtabs false")
	vis:command("set expandtab on")
	vis:command("set shell /usr/bin/env zsh")
	vis:map(vis.modes.VISUAL," y", '"+y"')
	vis:map(vis.modes.NORMAL, " f", function()
		vis:command("open .")
		vis:feedkeys("<C-w>k")
		vis:command("wq!")
	end, "")
end)

								-- plugins --

local modal = require('plugins/modal')
local lsp = require('plugins/vis-lspc')
lsp.ls_map.go = {
  name = "gopls",
  cmd = "gopls",
	 settings = {
		 Go = {diagnostics = { globals = {'go'}}, telemetry = {enable = false}},
	 },
	 formatting_options = {tabSize = 2, insertSpaces = true},
}
 lsp.ls_map.lua = {
	 name = 'lua-language-server',
	 cmd = 'lua-language-server',
	 settings = {
		 Lua = {diagnostics = { globals = {'vis'}}, telemetry = {enable = false}},
	 },
	 formatting_options = {tabSize = 2, insertSpaces = true},
 }
