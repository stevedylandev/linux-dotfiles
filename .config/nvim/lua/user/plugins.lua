local fn = vim.fn

-- Automatically install packer

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing Packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins
  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
  use "numToStr/Comment.nvim"
  use "JoosepAlviste/nvim-ts-context-commentstring"
  use "nvim-tree/nvim-web-devicons"
  use "kyazdani42/nvim-tree.lua"
  use { "akinsho/bufferline.nvim", commit = "83bf4dc7bff642e145c8b4547aa596803a8b4dc4" }
  use "moll/vim-bbye"
  use "nvim-lualine/lualine.nvim"
  use { "akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" }
  use "ahmedkhalf/project.nvim"
  use "lewis6991/impatient.nvim"
  use "lukas-reineke/indent-blankline.nvim"
  use "goolord/alpha-nvim" -- homescreen
  use "folke/which-key.nvim" -- nice menu to see different key sets
  use 'iamcco/markdown-preview.nvim' -- markdown preview in browser
  use 'eandrju/cellular-automaton.nvim'
  use 'folke/zen-mode.nvim' -- focus on just the code
  -- Colorschemes
  use "folke/tokyonight.nvim"
  use 'shaunsingh/nord.nvim'
  use 'navarasu/onedark.nvim'
  use 'https://gitlab.com/__tpb/monokai-pro.nvim'
  use { "catppuccin/nvim", as = "catppuccin" }
  use 'neg-serg/neg.nvim'


  --LSP New
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      { 'williamboman/mason.nvim' }, -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' }, -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'hrsh7th/cmp-buffer' }, -- Optional
      { 'hrsh7th/cmp-path' }, -- Optional
      { 'saadparwaiz1/cmp_luasnip' }, -- Optional
      { 'hrsh7th/cmp-nvim-lua' }, -- Optional

      -- Snippets
      { 'L3MON4D3/LuaSnip' }, -- Required
      { 'rafamadriz/friendly-snippets' }, -- Optional
    }
  }
  use { "folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons" }
  use 'windwp/nvim-ts-autotag'
  use 'rvmelkonian/move.vim' -- move analyzer
  use "roobert/tailwindcss-colorizer-cmp.nvim"
  -- Telescope
  use "nvim-telescope/telescope.nvim"

  -- Treesitter
  use "nvim-treesitter/nvim-treesitter"
  use 'NvChad/nvim-colorizer.lua'
  use { "preservim/vim-markdown", requires = "godlygeek/tabular" }

  -- Git
  use "lewis6991/gitsigns.nvim"
  --use "sindrets/diffview.nvim"

  --Rust
  use "Saecki/crates.nvim"

  --Astro
  use 'wuelnerdotexe/vim-astro'

  -- OpenAI
  use 'MunifTanjim/nui.nvim'
  use 'Bryley/neoai.nvim'


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
