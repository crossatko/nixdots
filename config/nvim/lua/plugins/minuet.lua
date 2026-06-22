return {
  "milanglacier/minuet-ai.nvim",
  event = "InsertEnter",
  -- Set OPENROUTER_API_KEY in your env before launching nvim
  -- (sourced from ~/.config/secrets/env via .zshrc).
  -- Get a key at: https://openrouter.ai/keys
  opts = {
    provider = "openai_compatible",
    request_timeout = 3,

    -- Don't expose minuet through blink.cmp (we use virtual text for
    -- copilot-style inline ghost text instead). blink still handles
    -- LSP/path/snippets/buffer completions normally.
    blink = {
      enable_auto_complete = false,
    },

    -- Virtual text frontend: shows inline ghost text at the cursor,
    -- accepted with <C-l>. This is the closest match to copilot's UX.
    virtualtext = {
      auto_trigger_ft = { "*" },
      auto_trigger_ignore_ft = {
        -- Non-code / prompt buffers where AI suggestions would be noise.
        "help",
        "lazy",
        "TelescopePrompt",
        "terminal",
        "trouble",
        "qf",
        "fugitive",
        "fugitiveblame",
        "git",
        "gitcommit",
        "gitrebase",
        "DressingInput",
        "neo-tree",
        "noice",
        "notify",
        "alpha",
        "snacks_dashboard",
        "starter",
        "lspinfo",
        "checkhealth",
        "lspconfig",
        "neogit",
        "neogitlog",
        "DiffviewFiles",
        "DiffviewFileHistory",
        "toggleterm",
        "lazy.term",
      },
      keymap = {
        -- Accept the full ghost-text suggestion (matches old copilot.lua).
        accept = "<C-l>",
        accept_line = false,
        accept_n_lines = false,
        prev = false,
        next = false,
        dismiss = "<C-]>",
      },
      -- Don't render ghost text while the blink.cmp popup is open.
      show_on_completion_menu = false,
    },

    provider_options = {
      openai_compatible = {
        name = "Openrouter",
        api_key = "OPENROUTER_API_KEY",
        end_point = "https://openrouter.ai/api/v1/chat/completions",
        model = "qwen/qwen3-coder-30b-a3b-instruct",
        optional = {
          max_tokens = 256,
          top_p = 0.9,
          provider = { sort = "throughput" },
        },
      },
    },
  },
}
