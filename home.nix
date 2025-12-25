{ config
, pkgs
, ...
}:

let
  user = "kreejzak";
  dotfiles = "${config.home.homeDirectory}/dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    hypr = "hypr";
    zellij = "zellij";
    nvim = "nvim";
    tofi = "tofi";
    waybar = "waybar";
  };
in
{
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    sessionPath = [
      "$HOME/.local/bin"
    ];

    sessionVariables =
      {
        XDG_DATA_DIRS = "$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
        GTK_THEME = "Adwaita-dark";
      };

    stateVersion = "25.11";

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

    packages = with pkgs; [
      brave
      nerd-fonts.comic-shanns-mono
      zellij
      wl-clipboard
      gnumake
      gcc
      binutils
      desktop-file-utils
      thunderbird
      btop
      mpv
      swappy
      imv
      pavucontrol
      networkmanagerapplet
      yazi
      fastfetch
      nautilus
      gvfs
      adwaita-icon-theme
      glib
      waybar
      tldr
    ];
  };

  imports = [
    ./modules/home/nvim.nix
    ./modules/home/kitty.nix
    ./modules/home/tableplus.nix
  ];

  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          extraOptions = {
            IdentityAgent = "~/.1password/agent.sock";
          };
        };
      };
    };

    brave = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; }
        { id = "nhdogjmejiglipccpnnnanhbledajbpd"; }
        { id = "jabopobgcpjmedljpbcaablpmlmfcogm"; }
        { id = "gebbhagfogifgggkldgodflihgfeippi"; }
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
      ];
    };

    git = {
      enable = true;
      settings = {
        pull.rebase = true;
        user = {
          name = "Paul Cross";
          email = "me@paulcross.cz";
        };
      };
    };

    home-manager.enable = true;


    bash = {
      enable = true;
    };

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
        udd = "update-desktop-database ~/.local/share/applications";
        rb = "pushd ~/dotfiles && sudo nixos-rebuild switch --flake . && popd && udd";
        rbu = "pushd ~/dotfiles && nix flake update && sudo nixos-rebuild switch --flake . && popd && udd";
      };
    };

    starship = {
      enable = true;
      settings = {
        add_newline = true;
      };
    };
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  services.blueman-applet.enable = true;

}
