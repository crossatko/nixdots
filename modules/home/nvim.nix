{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
    extraPackages = with pkgs; [
      lua
      lua-language-server
      stylua
      ripgrep
      fzf
      fd
      lazygit
      nodejs
      cargo
      unzip
      tree-sitter
      nixfmt-rfc-style
      bash-language-server
      emmet-ls
      vscode-langservers-extracted
      marksman
      nil
      nixpkgs-fmt
      prettier
      shfmt
      tailwindcss-language-server

      # Use these top-level names instead of nodePackages
      vtsls # This replaces nodePackages.vtsls
      vue-language-server # This replaces nodePackages.volar
      taplo # This replaces nodePackages.taplo

      hyprls
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
      inotify-tools

      # If you still need these specific ones:
      typescript-language-server
    ];
  };



}
