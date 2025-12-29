{ pkgs, lib, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # --------------------------------------------------------------------------
    # 1. GENERAL OPTIONS
    # --------------------------------------------------------------------------
    globals = {
      mapleader = " ";
      maplocalleader = "\\";
      autoformat = true;
      trouble_lualine = true;
    };

    opts = {
      autowrite = true;
      clipboard = "unnamedplus";
      completeopt = "menu,menuone,noselect";
      conceallevel = 2;
      confirm = true;
      cursorline = true;
      expandtab = true;
      formatoptions = "jcroqlnt";
      grepformat = "%f:%l:%c:%m";
      grepprg = "rg --vimgrep";
      ignorecase = true;
      inccommand = "nosplit";
      laststatus = 3;
      list = true;
      mouse = "a";
      number = true;
      pumblend = 10;
      pumheight = 10;
      relativenumber = true;
      scrolloff = 4;
      sessionoptions = [
        "buffers"
        "curdir"
        "tabpages"
        "winsize"
        "help"
        "globals"
        "skiprtp"
        "folds"
      ];
      shiftround = true;
      shiftwidth = 2;
      tabstop = 2;
      sidescrolloff = 8;
      signcolumn = "yes";
      smartcase = true;
      smartindent = true;
      spelllang = [ "en" ];
      splitbelow = true;
      splitkeep = "screen";
      splitright = true;
      termguicolors = true;
      timeoutlen = 300;
      undofile = true;
      undolevels = 10000;
      updatetime = 200;
      virtualedit = "block";
      wrap = false;
    };

    # --------------------------------------------------------------------------
    # 2. COLORSCHEME
    # --------------------------------------------------------------------------
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "storm";
        transparent = false;
        terminal_colors = true;
        styles = {
          comments = {
            italic = true;
          };
          keywords = {
            italic = true;
          };
          sidebars = "dark";
          floats = "dark";
        };
      };
    };

    # --------------------------------------------------------------------------
    # 3. PACKAGES
    # --------------------------------------------------------------------------
    extraPackages = with pkgs; [
      lua-language-server
      vscode-langservers-extracted
      marksman
      nixd
      basedpyright
      intelephense
      vue-language-server
      typescript-language-server
      clang-tools
      prettierd
      stylua
      shfmt
      black
      isort
      nixfmt-rfc-style
      eslint_d
      pylint
      ripgrep
      fd
      git
      fzf
    ];

    # --------------------------------------------------------------------------
    # 4. PLUGINS
    # --------------------------------------------------------------------------
    plugins = {

      lazydev.enable = true;
      persistence.enable = true;
      web-devicons.enable = true;

      # --- UI Components ---

      # Neo-tree (Replaces Snacks Explorer)
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
        sources = [
          "filesystem"
          "buffers"
          "git_status"
          "document_symbols"
        ];
        popupBorderStyle = "rounded";
        filesystem = {
          bindToCwd = false;
          followCurrentFile = {
            enabled = true;
          };
          useLibuvFileWatcher = true;
        };
        window = {
          width = 30;
          mappings = {
            "" = "none";
          };
        };
        defaultComponentConfigs = {
          indent = {
            withExpanders = true;
            expanderCollapsed = "";
            expanderExpanded = "";
            expanderHighlight = "NeoTreeExpander";
          };
        };
      };

      # Noice (Configured to silence paste messages)
      noice = {
        enable = true;
        settings = {
          lsp = {
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            lsp_doc_border = true;
          };
          # Disable Paste/Yank Popups
          routes = [
            {
              filter = {
                event = "msg_show";
                kind = "";
                find = "written";
              };
              opts = {
                skip = true;
              };
            }
            {
              filter = {
                event = "msg_show";
                find = "yanked";
              };
              opts = {
                skip = true;
              };
            }
            {
              filter = {
                event = "msg_show";
                find = "%d+L, %d+B"; # "10L, 50B" written messages
              };
              opts = {
                skip = true;
              };
            }
          ];
        };
      };

      notify = {
        enable = true;
        settings = {
          stages = "static"; # No animation for notifications
          timeout = 3000;
        };
      };

      dressing.enable = true;

      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "tokyonight";
            globalstatus = true;
            disabled_filetypes = {
              statusline = [
                "dashboard"
                "alpha"
                "starter"
                "neo-tree"
              ];
            };
          };
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [ "branch" ];
            lualine_c = [
              {
                __unkeyed-1 = "diagnostics";
                symbols = {
                  error = " ";
                  warn = " ";
                  info = " ";
                  hint = " ";
                };
              }
              {
                __unkeyed-1 = "filetype";
                icon_only = true;
                padding = {
                  left = 1;
                  right = 0;
                };
              }
              {
                __unkeyed-1 = "filename";
                path = 1;
              }
            ];
            lualine_x = [
              {
                __unkeyed-1 = "diff";
                symbols = {
                  added = " ";
                  modified = " ";
                  removed = " ";
                };
              }
            ];
            lualine_y = [
              "progress"
              "location"
            ];
            lualine_z = [
              {
                __unkeyed-1 = "datetime";
                style = "%R";
              }
            ];
          };
        };
      };

      bufferline = {
        enable = true;
        settings = {
          options = {
            always_show_bufferline = false;
            diagnostics = "nvim_lsp";
            close_command = "bdelete! %d";
            offsets = [
              {
                filetype = "neo-tree";
                text = "Neo-tree";
                highlight = "Directory";
                text_align = "left";
              }
            ];
          };
        };
      };

      # --- Snacks (Animations DISABLED) ---
      snacks = {
        enable = true;
        settings = {
          bigfile = {
            enabled = true;
          };
          indent = {
            enabled = true;
          };
          input = {
            enabled = true;
          };
          notifier = {
            enabled = true;
          };
          quickfile = {
            enabled = true;
          };
          scope = {
            enabled = true;
          };
          # Explicitly Disable Scroll Animation
          scroll = {
            enabled = false;
          };
          statuscolumn = {
            enabled = true;
          };
          words = {
            enabled = true;
          };
          lazygit = {
            enabled = true;
          };

          dashboard = {
            enabled = true;
            sections = [
              { section = "header"; }
              {
                icon = " ";
                title = "Keymaps";
                section = "keys";
                indent = 2;
                padding = 1;
              }
              {
                icon = " ";
                title = "Recent Files";
                section = "recent_files";
                indent = 2;
                padding = 1;
              }
              {
                icon = " ";
                title = "Projects";
                section = "projects";
                indent = 2;
                padding = 1;
              }
              {
                section = "terminal";
                cmd = "echo 'LazyVim on Nixvim'";
                height = 5;
                padding = 1;
              }
            ];
            preset = {
              header = [
                "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
                "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
                "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
                "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
                "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
                "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
              ];
            };
          };
          # Disabled Snacks Picker/Explorer in favor of Fzf-Lua/Neo-tree
          picker = {
            enabled = false;
          };
          explorer = {
            enabled = false;
          };
        };
      };

      # --- Fzf-Lua (Replaces Picker) ---
      fzf-lua = {
        enable = true;
        profile = "default-title";
      };

      # --- Coding ---
      flash.enable = true;

      gitsigns = {
        enable = true;
        settings.signs = {
          add = {
            text = "▎";
          };
          change = {
            text = "▎";
          };
          delete = {
            text = "";
          };
          topdelete = {
            text = "";
          };
          changedelete = {
            text = "▎";
          };
        };
      };

      trouble.enable = true;
      todo-comments.enable = true;

      mini = {
        enable = true;
        modules = {
          ai = {
            n_lines = 500;
          };
          surround = { };
          pairs = { };
          comment = { };
          bufremove = { };
          indentscope = {
            symbol = "│";
            options = {
              try_as_border = true;
            };
          };
          # Removed mini.animate implicit default
        };
      };

      which-key = {
        enable = true;
        settings = {
          preset = "helix";
        };
      };

      # --- Completion ---
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "enter";
          };
          appearance = {
            use_nvim_cmp_as_default = true;
            nerd_font_variant = "mono";
          };
          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];
          };
          signature = {
            enabled = true;
          };
        };
      };

      # --- Formatting ---
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };
          formatters_by_ft = {
            lua = [ "stylua" ];
            sh = [ "shfmt" ];
            nix = [ "nixfmt" ];
            python = [
              "isort"
              "black"
            ];
            rust = [ "rustfmt" ];
            javascript = [ "prettierd" ];
            typescript = [ "prettierd" ];
            javascriptreact = [ "prettierd" ];
            typescriptreact = [ "prettierd" ];
            vue = [ "prettierd" ];
            css = [ "prettierd" ];
            html = [ "prettierd" ];
            json = [ "prettierd" ];
            markdown = [ "prettierd" ];
            php = [ "prettierd" ];
          };
        };
      };

      # --- Linting ---
      lint = {
        enable = true;
        lintersByFt = {
          javascript = [ "eslint_d" ];
          typescript = [ "eslint_d" ];
          javascriptreact = [ "eslint_d" ];
          typescriptreact = [ "eslint_d" ];
          vue = [ "eslint_d" ];
          python = [ "pylint" ];
        };
      };

      # --- LSP ---
      lsp = {
        enable = true;
        inlayHints = true;

        keymaps = {
          silent = true;
          lspBuf = {
            definition = "gd";
            references = "gr";
            declaration = "gD";
            implementation = "gI";
            type_definition = "gy";
            hover = "K";
            rename = "cr";
            code_action = "ca";
          };
        };

        servers = {
          html = {
            enable = true;
            package = pkgs.vscode-langservers-extracted;
          };
          cssls = {
            enable = true;
            package = pkgs.vscode-langservers-extracted;
          };
          jsonls = {
            enable = true;
            package = pkgs.vscode-langservers-extracted;
          };

          nixd = {
            enable = true;
            package = pkgs.nixd;
          };
          marksman = {
            enable = true;
            package = pkgs.marksman;
          };
          basedpyright = {
            enable = true;
            package = pkgs.basedpyright;
          };
          intelephense = {
            enable = true;
            package = pkgs.intelephense;
          };
          clangd = {
            enable = true;
            package = pkgs.clang-tools;
            cmd = [
              "clangd"
              "--offset-encoding=utf-16"
            ];
          };

          volar = {
            enable = true;
            package = pkgs.vue-language-server;
            extraOptions.init_options.vue.hybridMode = true;
          };

          ts_ls = {
            enable = true;
            package = pkgs.typescript-language-server;
            filetypes = [
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
              "vue"
            ];
            extraOptions = {
              init_options = {
                plugins = lib.mkForce [
                  {
                    name = "@vue/typescript-plugin";
                    location = "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server";
                    languages = [ "vue" ];
                  }
                ];
              };
            };
          };
        };
      };

      # Rust
      rustaceanvim = {
        enable = true;
        settings = {
          server = {
            default_settings = {
              rust-analyzer = {
                cargo = {
                  allFeatures = true;
                };
                check = {
                  command = "clippy";
                };
              };
            };
          };
        };
      };

      # --- TREESITTER ---
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          c
          cpp
          css
          html
          javascript
          json
          lua
          markdown
          markdown_inline
          nix
          php
          python
          rust
          tsx
          typescript
          vim
          vimdoc
          vue
          yaml
        ];
        settings = {
          highlight = {
            enable = true;
          };
          indent = {
            enable = true;
          };
        };
      };
      ts-autotag.enable = true;
      ts-context-commentstring.enable = true;
    };

    # --------------------------------------------------------------------------
    # 5. KEYMAPS (Standard LazyVim Mappings using Fzf-Lua & Neo-tree)
    # --------------------------------------------------------------------------
    keymaps = [
      # Window
      {
        mode = "n";
        key = "";
        action = "h";
        options = {
          desc = "Go to Left Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "";
        action = "j";
        options = {
          desc = "Go to Lower Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "";
        action = "k";
        options = {
          desc = "Go to Upper Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "";
        action = "l";
        options = {
          desc = "Go to Right Window";
          remap = true;
        };
      }

      # Buffers
      {
        mode = "n";
        key = "";
        action = "bprevious";
        options = {
          desc = "Prev Buffer";
        };
      }
      {
        mode = "n";
        key = "";
        action = "bnext";
        options = {
          desc = "Next Buffer";
        };
      }
      {
        mode = "n";
        key = "bd";
        action = "lua MiniBufremove.delete(0, false)";
        options = {
          desc = "Delete Buffer";
        };
      }

      # Files
      {
        mode = "n";
        key = "fn";
        action = "enew";
        options = {
          desc = "New File";
        };
      }

      # Fzf-Lua (Picker Mappings)
      {
        mode = "n";
        key = "";
        action = "FzfLua files";
        options = {
          desc = "Find Files (Root Dir)";
        };
      }
      {
        mode = "n";
        key = "ff";
        action = "FzfLua files";
        options = {
          desc = "Find Files (Root Dir)";
        };
      }
      {
        mode = "n";
        key = "fb";
        action = "FzfLua buffers";
        options = {
          desc = "Buffers";
        };
      }
      {
        mode = "n";
        key = ",";
        action = "FzfLua buffers";
        options = {
          desc = "Switch Buffer";
        };
      }
      {
        mode = "n";
        key = "fg";
        action = "FzfLua git_files";
        options = {
          desc = "Find Git Files";
        };
      }
      {
        mode = "n";
        key = "fr";
        action = "FzfLua oldfiles";
        options = {
          desc = "Recent";
        };
      }

      # Grep / Search
      {
        mode = "n";
        key = "/";
        action = "FzfLua live_grep";
        options = {
          desc = "Grep (Root Dir)";
        };
      }
      {
        mode = "n";
        key = "sg";
        action = "FzfLua live_grep";
        options = {
          desc = "Grep (Root Dir)";
        };
      }
      {
        mode = "n";
        key = "sw";
        action = "FzfLua grep_cword";
        options = {
          desc = "Word (Root Dir)";
        };
      }
      {
        mode = "n";
        key = "s:";
        action = "FzfLua command_history";
        options = {
          desc = "Command History";
        };
      }

      # Neo-tree (Explorer)
      {
        mode = "n";
        key = "e";
        action = "Neotree toggle";
        options = {
          desc = "Explorer NeoTree (Root Dir)";
        };
      }
      {
        mode = "n";
        key = "E";
        action = "Neotree toggle cwd";
        options = {
          desc = "Explorer NeoTree (cwd)";
        };
      }

      # Git
      {
        mode = "n";
        key = "gg";
        action = "lua Snacks.lazygit()";
        options = {
          desc = "Lazygit";
        };
      }
      {
        mode = "n";
        key = "gb";
        action = "lua Snacks.git.blame_line()";
        options = {
          desc = "Git Blame Line";
        };
      }

      # Format
      {
        mode = [
          "n"
          "v"
        ];
        key = "cf";
        action = "lua require('conform').format({ lsp_fallback = true })";
        options = {
          desc = "Format";
        };
      }
    ];

    autoGroups = {
      highlight_yank = {
        clear = true;
      };
    };

    autoCmd = [
      {
        event = [ "TextYankPost" ];
        callback = {
          __raw = "function() vim.highlight.on_yank() end";
        };
        group = "highlight_yank";
      }
      {
        event = [ "FileType" ];
        pattern = [
          "qf"
          "help"
          "man"
          "notify"
          "lspinfo"
          "spectre_panel"
          "startuptime"
          "tsplayground"
          "PlenaryTestPopup"
        ];
        command = "nnoremap   q :close";
      }
      {
        event = [ "FileType" ];
        pattern = [
          "gitcommit"
          "markdown"
        ];
        command = "setlocal wrap spell";
      }
    ];
  };
}
