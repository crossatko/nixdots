return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- 1. Modern way to disable <C-k> (No deprecation warning)
      servers = {
        ["*"] = {
          keys = {
            { "<C-k>", false, mode = "i" },
          },
        },
        -- 2. Define your Nix-installed servers
        tailwindcss = {},
        jsonls = {},
        bashls = {},
        volar = {
          cmd = { "vue-language-server", "--stdio" },
          filetypes = { "vue" },
        }, -- Use 'volar', not 'vue_ls'
        vtsls = {},
        emmet_ls = {},
        nil_ls = {}, -- Nix LSP
      },
      -- 3. Point VTSLS to the Nix store path for the Vue plugin
      setup = {
        vtsls = function(_, opts)
          opts.settings = opts.settings or {}
          opts.settings.vtsls = opts.settings.vtsls or {}
          opts.settings.vtsls.tsserver = opts.settings.vtsls.tsserver or {}

          -- DYNAMIC PATH FROM YOUR SUCCESSFUL TERMINAL TEST
          local vue_plugin_path = (function()
            local handle = io.popen("readlink -f $(which vue-language-server) 2>/dev/null")
            local res = handle:read("*a"):gsub("%s+", "")
            handle:close()
            if res == "" then
              return nil
            end
            return res:gsub("/bin/vue%-language%-server$", "/lib/language-tools/packages/typescript-plugin")
          end)()

          -- Only apply if path exists to prevent the crash loop
          if vue_plugin_path and vim.loop.fs_stat(vue_plugin_path) then
            -- opts.settings.vtsls.tsserver.globalPlugins = {
            --   {
            --     name = "@vue/typescript-plugin",
            --     location = vue_plugin_path,
            --     languages = { "vue" },
            --     configNamespace = "typescript",
            --     enableForWorkspaceTypeScriptVersions = true,
            --   },
            -- }
          end
        end,
      },
    },
  },
}
