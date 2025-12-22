{
  config,
  pkgs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    hypr = "hypr";
    zellij = "zellij";
    nvim = "nvim";
  };

in
{
  home = {
    username = "kreejzak";
    homeDirectory = "/home/kreejzak";

    sessionPath = [
      "$HOME/.local/bin"
    ];

    stateVersion = "25.11";

    packages = with pkgs; [
      brave
      nerd-fonts.comic-shanns-mono
      zellij
      wl-clipboard
      gnumake
      gcc
      binutils
      desktop-file-utils
      btop
      mpv
      swappy
      imv
      pavucontrol
      networkmanagerapplet
      yazi
    ];
  };

  imports = [
    ./modules/home/nvim.nix
    ./modules/home/kitty.nix
  ];

  programs = {
    git = {
      enable = true;
      settings.user = {
        name = "Paul Cross";
        email = "me@paulcross.cz";
      };
    };

    home-manager.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
      };

      shellAliases = {
        rb = "pushd ~/dotfiles && nix flake update && sudo nixos-rebuild switch --flake . && popd";
      };
    };

    starship = {
      enable = true;
      settings = {
        add_newline = true;
      };
    };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  fonts.fontconfig.enable = true;
}
