local lsp = require('lsp-zero').preset({
  name = 'recommended',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
  sign_icons = { error = "", warn = "", info = ""},
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr}
  local bind = vim.keymap.set

  bind('n', '<leader>l', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
  bind('n', '<leader>f', '<cmd>LspZeroFormat <cr>', opts)
end)

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup_nvim_cmp({
  formatting = {
    format = require("tailwindcss-colorizer-cmp").formatter
  }
})

lsp.setup()
