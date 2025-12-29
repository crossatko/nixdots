return {
  on_attach = function(client, bufnr)
    -- Add any custom on_attach logic here
  end,
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  },
}
