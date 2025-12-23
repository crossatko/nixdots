return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          treesitter = true,
          notify = true,
          mini = true,
        },
        custom_highlights = function(colors)
          return {
            Normal = { bg = "NONE" },
            NormalNC = { bg = "NONE" },
            NormalFloat = { bg = "NONE" },
            FloatBorder = { bg = "NONE" },
            VertSplit = { bg = "NONE" },
            SignColumn = { bg = "NONE" },
            StatusLine = { bg = "NONE" },
            StatusLineNC = { bg = "NONE" },
            TabLine = { bg = "NONE" },
            TabLineFill = { bg = "NONE" },
            TabLineSel = { bg = "NONE" },
            Pmenu = { bg = "NONE" },
            PmenuSel = { bg = "NONE" },
            PmenuSbar = { bg = "NONE" },
            PmenuThumb = { bg = "NONE" },
            WinSeparator = { bg = "NONE" },
            CursorLine = { bg = "NONE" },
            CursorLineNr = { bg = "NONE" },
            LineNr = { bg = "NONE" },
            Folded = { bg = "NONE" },
            FoldColumn = { bg = "NONE" },
            EndOfBuffer = { bg = "NONE" },
          }
        end,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
      transparent = true,
    },
  },
}
