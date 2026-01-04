{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      stylua
      ripgrep
      fzf
      fd
      lazygit
      nodejs
      cargo
      gcc
      gnumake
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
      nodePackages.typescript
      taplo
      hyprls
      inotify-tools
      typescript-language-server

      # Optional: runtime libs (not strictly needed with nix-ld, but harmless)
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
    ];
  };
}
