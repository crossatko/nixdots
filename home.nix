{ config, pkgs, inputs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    hypr = "hypr";
    zellij = "zellij";
  };

in {
  home.username = "kreejzak";
  home.homeDirectory = "/home/kreejzak";

  home.stateVersion = "25.11";

  imports = [
    ./modules/home/noctalia.nix
    ./modules/home/nixvim.nix
    ./modules/home/kitty.nix
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "Paul Cross";
      email = "me@paulcross.cz";
    };
  };

  programs.home-manager.enable = true;

  programs.bash = { enable = true; };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [ brave nerd-fonts.comic-shanns-mono zellij ];
}
