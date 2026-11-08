local lexers = vis.lexers

local br_black = '8'       -- color8
local red      = 'red'     -- color1   bright = 9
local green    = 'green'   -- color2   bright = 10
local yellow   = 'yellow'  -- color3   bright = 11 
local blue     = 'blue'    -- color4   bright = 12
local magenta  = 'magenta' -- color5   bright = 13
local cyan     = 'cyan'    -- color6   bright = 14

lexers.STYLE_DEFAULT = 'back:default,fore:default'
lexers.STYLE_NOTHING = 'back:default'
lexers.STYLE_CLASS = 'fore:'..cyan..',bold'
lexers.STYLE_COMMENT = 'fore:'..blue
lexers.STYLE_CONSTANT = 'fore:'..cyan
lexers.STYLE_DEFINITION = 'fore:default'
lexers.STYLE_ERROR = 'fore:'..red
lexers.STYLE_FUNCTION = 'fore:'..yellow
lexers.STYLE_KEYWORD = 'fore:'..red
lexers.STYLE_LABEL = 'fore:default'
lexers.STYLE_NUMBER = 'fore:'..magenta
lexers.STYLE_OPERATOR = 'fore:default'
lexers.STYLE_REGEX = 'fore:default'
lexers.STYLE_STRING = 'fore:'..green
lexers.STYLE_PREPROCESSOR = 'fore:default'
lexers.STYLE_TAG = 'fore:default'
lexers.STYLE_TYPE = 'fore:'..cyan..',bold'
lexers.STYLE_VARIABLE = 'fore:default'
lexers.STYLE_WHITESPACE = ''
lexers.STYLE_EMBEDDED = 'fore:default'
lexers.STYLE_IDENTIFIER = 'fore:'..blue
lexers.STYLE_LINENUMBER = 'fore:'..br_black
lexers.STYLE_LINENUMBER_CURSOR = 'fore:'..green
lexers.STYLE_CURSOR = 'fore:black,back:15'
lexers.STYLE_CURSOR_PRIMARY = lexers.STYLE_CURSOR
lexers.STYLE_CURSOR_LINE = 'underlined'
lexers.STYLE_COLOR_COLUMN = 'back:'..br_black
lexers.STYLE_SELECTION = 'back:'..br_black..',fore:black'
lexers.STYLE_STATUS = 'back:'..br_black..',fore:'..cyan
lexers.STYLE_STATUS_FOCUSED = 'back:15,fore:black,bold'
lexers.STYLE_SEPARATOR = lexers.STYLE_DEFAULT
lexers.STYLE_INFO = 'bold'
lexers.STYLE_EOF = ''
