return {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
        require("rose-pine").setup({
            extend_background_behind_borders = false,
            styles = {
                bold = true,
                italic = true,
                transparency = true,
            },
        })

        vim.cmd("colorscheme rose-pine")
    end,
}
