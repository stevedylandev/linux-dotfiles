--[[

	modal
	the status line colorizer for vis

]]

require('vis')

local M = {}

local MODAL_STYLE = 51
local MODAL_STYLE_INVERTED = 52

local MODES = {
	[vis.modes.NORMAL] = ' NORMAL ',
	[vis.modes.INSERT] = ' INSERT ',
	[vis.modes.VISUAL] = ' VISUAL ',
	[vis.modes.REPLACE] = ' REPLACE ',
	[vis.modes.VISUAL_LINE] = ' VISUAL_LINE ',
	[vis.modes.OPERATOR_PENDING] = ' OPERATOR_PENDING ',
}
M.MODES = MODES


local STYLES = {
	[vis.modes.NORMAL] = {
		REGULAR = 'fore:default,back:black',
		INVERTED = 'fore:yellow,back:black',
	},
	[vis.modes.INSERT] = {
		REGULAR = 'fore:default,back:green',
		INVERTED = 'fore:green,back:black',
	},
	[vis.modes.VISUAL] = {
		REGULAR = 'fore:default,back:magenta',
		INVERTED = 'fore:magenta,back:black',
	},
	[vis.modes.REPLACE] = {
		REGULAR = 'fore:default,back:blue',
		INVERTED = 'fore:blue,back:black',
	},
	[vis.modes.VISUAL_LINE] = {
		REGULAR = 'fore:default,back:magenta',
		INVERTED = 'fore:magenta,back:black',
	},
	[vis.modes.OPERATOR_PENDING] = {
		REGULAR = 'fore:default,back:blue',
		INVERTED = 'fore:blue,back:black',
	},
	UNFOCUSED = {
		REGULAR = 'fore:default,back:black',
		INVERTED = 'fore:white,back:black',
	},
}
M.STYLES = STYLES

vis.events.subscribe(vis.events.WIN_STATUS, function(win)
	local modified = ''
	if win.file.modified then modified = ' *' end
	local filename = ' [NO NAME]'..modified..' '
	if win.file.name then filename = ' '..win.file.name..modified..' ' end
	local vmode = MODES[vis.mode]
	local recording = ''
	if vis.recording then
		recording = ' @ RECORDING'
	end
	status_left = vmode..filename..recording

	cursors = 0
	for _ in win:selections_iterator() do cursors = cursors+1 end
	selection_size = "SELECTION_SIZE: "..
		win.selection.range.finish - win.selection.range.start
	cursor_amount = "CURSORS: "..cursors
	cursor_pos = win.selection.line..":"..win.selection.col
	status_right = selection_size.." | "..cursor_amount.." | "..cursor_pos

	win:status(status_left, status_right)

	for win in vis:windows() do
		if win == vis.win then
			win:style_define(MODAL_STYLE,						STYLES[vis.mode].REGULAR)
			win:style_define(MODAL_STYLE_INVERTED,	STYLES[vis.mode].INVERTED)
		else
			win:style_define(MODAL_STYLE,						STYLES.UNFOCUSED.REGULAR)
			win:style_define(MODAL_STYLE_INVERTED,	STYLES.UNFOCUSED.INVERTED)
		end
	end

	for i=0,win.width do
		win:style_pos(MODAL_STYLE, i, win.height - 1)
	end
	for i=string.len(vmode),string.len(vmode)+string.len(filename)-1 do
		win:style_pos(MODAL_STYLE_INVERTED, i, win.height - 1)
	end
end)


return M
