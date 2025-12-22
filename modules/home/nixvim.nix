{ pkgs, inputs, ... }:

{

  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      smartindent = true;
      mouse = "a";
      undofile = true;
      signcolumn = "yes";
      clipboard = "unnamedplus";
    };

    clipboard.providers.wl-copy.enable = true;

    globals.mapleader = " ";

    termguicolors = true;
    background = "dark";

    highlight = {
      Normal.bg = "none";
      NonText.bg = "none";
      SignColumn.bg = "none";
      StatusLine.bg = "none";

    };

    # colorschemes.tokyonight = {
    #   enable = true;
    #   settings.theme = "night";
    # };

    plugins = {
      lualine.enable = true;
      bufferline.enable = true;
      treesitter.enable = true;
      transparent.enable = true;

      web-devicons.enable = true;

      lazygit.enable = true;

      refactoring.enable = true;

      fzf-lua = {
        enable = true;
        profile = "fzf-native";

      };

      cmp = {
        enable = true;
        autoEnableSources = true;

        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
          ];

          mapping = {
            "<C-l>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({select = true})";
          };

          window = {
            completion.border = "rounded";
            documentation.border = "rounded";
          };
        };
      };

      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-burref.enable = true;
      luasnip.enable = true;
      cmp_luasnip.enable = true;

      neo-tree = {
        enable = true;
        close_if_last_window = true;
      };

      lsp = {
        enable = true;
        code_actions.enabled = true;
        servers = {
          nixd = {
            enable = true;
            settings = {
              formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
              nixpkgs = {
                expr = "import (buildins.getFlake (toString ./.)).inputs.nixpkgs { }";
              };
              nixos.expr = "(buildins.getFlake (toString ./.)).nixosConfigurations.CrossBattlestation.options";
              home-manager.expr = "(buildins.getFlake (toString ./.)).nixosConfigurations.CrossBattlestation.options.home-manager.users.type.getSubOptions []";

            };
          };
          bashls.enable = true;
          ts.enable = true;
        };
      };

      none-ls = {
        enable = true;
        sources.formatting.nixfmt.enable = true;
        sources.code_actions.statix.enable = true;
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options = {
          silent = true;
          desc = "LazyGit (Root Dir)";
        };
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options = {
          silent = true;
          desc = "Code actions";
        };
      }
      {
        mode = "n";
        key = "<leader><space>";
        action = "<cmd>FzfLua files<CR>";
        options.desc = "Find Files (fzf)";
      }
      {
        mode = "n";
        key = "<leader>sg";
        action = "<cmd>FzfLua live_grep<CR>";
        options = {
          silent = true;
          desc = "Search Grep";
        };
      }
      {
        mode = "n";
        key = "<leader>e";
        action = ":Neotree toggle<CR>";
        options.desc = "Toggle Neo-tree";
      }
      {
        mode = "n";
        key = "<C-h>";
        action = ":Neotree focus<CR>";
        options.desc = "Focus Neo-tree";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Focus Editor";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = ":bprev<CR>";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = ":bnext<CR>";
      }
    ];

    autoCmd = [
      {
        event = "BufWritePre";
        pattern = "*.*";
        command = "lua vim.lsp.buf.format()";
      }
    ];
  };

  home.packages = with pkgs; [
    fzf
    ripgrep
    fd
    lazygit
  ];
}
