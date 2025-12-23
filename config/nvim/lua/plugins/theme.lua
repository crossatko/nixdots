return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd.colorscheme("rose-pine")
      -- Set all backgrounds to none for transparency
      local groups = {
        -- Core UI
        "Normal", "NormalNC", "NormalFloat", "FloatBorder", "MsgArea", "MsgSeparator",
        "StatusLine", "StatusLineNC", "VertSplit", "SignColumn", "CursorLine", "CursorLineNr", "LineNr", "Folded", "FoldColumn", "WinSeparator",
        -- Telescope
        "TelescopeNormal", "TelescopeBorder", "TelescopePromptNormal", "TelescopePromptBorder", "TelescopeResultsNormal", "TelescopeResultsBorder", "TelescopePreviewNormal", "TelescopePreviewBorder",
        -- Completion
        "Pmenu", "PmenuSel", "PmenuSbar", "PmenuThumb",
        -- WhichKey
        "WhichKeyFloat",
        -- NvimTree
        "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeEndOfBuffer",
        -- cmp.nvim
        "CmpPmenu", "CmpPmenuBorder", "CmpPmenuSel", "CmpPmenuSbar", "CmpPmenuThumb",
        -- dressing.nvim
        "DressingInputNormal", "DressingInputBorder",
        -- fzf-lua
        "FzfLuaNormal", "FzfLuaBorder",
        -- LazyVim extras
        "LazyNormal", "LazyBorder"
      }
      local function clear_bg()
        for _, group in ipairs(groups) do
          vim.api.nvim_set_hl(0, group, { bg = "none" })
        end
      end
      clear_bg()
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = clear_bg,
      })

      -- Fix invisible popup selection and border backgrounds
      vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#000000", bg = "#ffffff", bold = true })
      vim.api.nvim_set_hl(0, "Pmenu", { fg = "#ffffff", bg = "#222222" })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#888888", bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#888888", bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#888888", bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#888888", bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#888888", bg = "NONE" })
      vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = "#888888", bg = "NONE" })
    end
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine"
    }
  }
}

