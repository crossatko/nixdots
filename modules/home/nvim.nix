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

      vtsls
      vue-language-server
      taplo

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

      typescript-language-server
    ];
  };
}
