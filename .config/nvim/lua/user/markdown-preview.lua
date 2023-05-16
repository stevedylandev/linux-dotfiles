local status_ok, markdown_preview = pcall(require, "markdown-preview")
if not status_ok then
	return
end

markdown_preview.setup({
  mkdp_auto_start = 1
})
