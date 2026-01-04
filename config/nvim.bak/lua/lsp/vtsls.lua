local vue_language_server_path = "/etc/profiles/per-user/kreejzak/lib/node_modules/@vue/language-server"

return {
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = false,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      typescript = {
        tsconfigPath = ".nuxt/tsconfig.json",
preferences = {
    includePackageJsonAutoImports = "auto",  -- Helps with auto-imports
  },
      },
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_language_server_path,
            languages = { "vue" },
          },
        },
      },
    },
  },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
}
