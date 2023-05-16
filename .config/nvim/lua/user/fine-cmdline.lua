local status_ok, finecmdline = pcall(require, "fine-cmdline")
if not status_ok then
	return
end

finecmdline.setup({
  cmdline = {
    enable_keymaps = true,
    smart_history = false
  },
  popup = {
    position = {
      row = '40%',
      col = '50%',
    },
    size = {
      width = '60%',
      height = 1
    },
    border = {
      style = 'rounded',
      highlight = 'FloatBorder',
    },
    win_options = {
      winhighlight = 'Normal:Normal',
    },
  },
})
