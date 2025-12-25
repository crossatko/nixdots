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
        volar = {}, -- Use 'volar', not 'vue_ls'
        vtsls = {},
        emmet_ls = {},
      },
      -- 3. Point VTSLS to the Nix store path for the Vue plugin
      setup = {
        vtsls = function(_, opts)
          opts.settings = opts.settings or {}
          opts.settings.vtsls = opts.settings.vtsls or {}
          opts.settings.vtsls.tsserver = opts.settings.vtsls.tsserver or {}

          -- Find the Nix path for vue-language-server
          -- On NixOS/Home-manager, this is usually ~/.nix-profile/lib/node_modules/...
          local vue_plugin_path = os.getenv("HOME") .. "/.nix-profile/lib/node_modules/@vue/language-server"

          opts.settings.vtsls.tsserver.globalPlugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_plugin_path,
              languages = { "vue" },
              configNamespace = "typescript",
              enableForWorkspaceTypeScriptVersions = true,
            },
          }
        end,
      },
    },
  },
}
