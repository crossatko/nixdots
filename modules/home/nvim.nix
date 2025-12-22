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
      vscode-langservers-extracted # for jsonls
      marksman # for markdown
      nil
      nixpkgs-fmt
      prettier
      shfmt
      tailwindcss-language-server
      vtsls
      vue-language-server
    ];
  };

}
