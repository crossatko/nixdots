return {
  {
    "carderne/pi-nvim",
    config = function(_, opts)
      require("pi-nvim").setup(opts)

      vim.keymap.set("n", "<leader>ai", ":PiSendBuffer<CR>", { desc = "Pi: Send buffer" })
      vim.keymap.set("v", "<leader>ai", ":PiSendSelection<CR>", { desc = "Pi: Send selection" })
      vim.keymap.set("v", "<leader>ps", ":PiSendSelection<CR>", { desc = "Pi: Send selection" })
    end,
  },
}
