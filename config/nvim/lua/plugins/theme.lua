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
          local active_bg = colors.surface2
          local active_fg = colors.mauve

          return {
            Normal = { bg = "NONE" },
            NormalNC = { bg = "NONE" },
            NormalFloat = { bg = "NONE" },
            FloatBorder = { bg = "NONE" },
            VertSplit = { bg = "NONE" },
            SignColumn = { bg = "NONE" },
            StatusLine = { bg = "NONE" },
            StatusLineNC = { bg = "NONE" },
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

            BufferLineFill = { bg = "NONE" },
            BufferLineBufferSelected = { bg = active_bg, fg = active_fg, bold = true },
            BufferLineModifiedSelected = { bg = active_bg, fg = colors.peach },
            BufferLineErrorSelected = { bg = active_bg, fg = colors.red, bold = true },
            BufferLineWarningSelected = { bg = active_bg, fg = colors.yellow, bold = true },
            BufferLineInfoSelected = { bg = active_bg, fg = colors.blue, bold = true },
            BufferLineHintSelected = { bg = active_bg, fg = colors.teal, bold = true },
            BufferLineErrorDiagnosticSelected = { bg = active_bg, fg = colors.red, bold = true },
            BufferLineWarningDiagnosticSelected = { bg = active_bg, fg = colors.yellow, bold = true },
            BufferLineInfoDiagnosticSelected = { bg = active_bg, fg = colors.blue, bold = true },
            BufferLineHintDiagnosticSelected = { bg = active_bg, fg = colors.teal, bold = true },
            BufferLineSeparatorSelected = { bg = active_bg, fg = active_bg },
            BufferLineCloseButtonSelected = { bg = active_bg, fg = colors.overlay0 },
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
