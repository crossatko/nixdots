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
    ];
  };

}
