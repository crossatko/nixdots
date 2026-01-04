return {
"nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.config")

      local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter_parsers"

      vim.opt.runtimepath:append(parser_install_dir)

      config.setup({
        parser_install_dir = parser_install_dir,

        ensure_installed = {
            "javascript", "typescript", "php", "lua", "nix", "html", "css", "vue", "c", "rust", "markdown"
        },
        sync_install = false,
        auto_install = true,

        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
}
