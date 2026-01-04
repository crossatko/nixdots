return {
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
    },
    init_options = {
        plugins = {
            {
                languages = { "vue" },
                location = vim.fn.stdpath("data")
                    .. "/etc/profiles/per-user/kreejzak/lib/node_modules/@vue/language-server",
                name = "@vue/typescript-plugin",
            },
        },
    },
}
