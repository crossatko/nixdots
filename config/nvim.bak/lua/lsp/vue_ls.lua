-- lsp/vue_ls.lua
local ts_lib_path = "/etc/profiles/per-user/kreejzak/lib/node_modules/typescript/lib"  -- From your tsserver path

return {
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  init_options = {
    typescript = {
      tsdk = ts_lib_path,  -- Your Nix-managed stable TS (avoids bugs, sees .nuxt/ via project context)
    },
    vue = {
      hybridMode = false,
    },
  },
}
