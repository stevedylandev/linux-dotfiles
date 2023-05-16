require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  },
  move = {
      icon = "",
      color = "#51a0cf",
      name = "Move"
    },
      astro = {
    icon = "",
    color = "#d18770",
    name = "Astro"
  }

 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}

require("nvim-web-devicons").set_icon {
  move = {
    icon = "",
    color = "#51a0cf",
    name = "Move"
  },
  astro = {
    icon = "",
    color = "#d18770",
    name = "Astro"
  }
}
