{ config
, pkgs
, lib
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

    sessionVariables = {
      XDG_DATA_DIRS = "$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
      GTK_USE_PORTAL = "1";
    };
    file.".icons/Bibata-Modern-Classic".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";

    stateVersion = "25.11";

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    packages = with pkgs; [
      nerd-fonts.comic-shanns-mono
      zellij
      wl-clipboard
      gnumake
      gcc
      binutils
      desktop-file-utils
      thunderbird
      mpv
      swappy
      imv
      pavucontrol
      networkmanagerapplet
      yazi
      nautilus
      gvfs
      glib
      waybar
      tldr
      trezor-suite
      gnome-disk-utility


      adwaita-icon-theme
      yaru-theme
      ubuntu-themes
      catppuccin-gtk
      catppuccin-kvantum

    ];
  };

  imports = [
    ./modules/home/nvim.nix
    ./modules/home/kitty.nix
    ./modules/home/tableplus.nix
  ];

  programs = {

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };


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
        { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
        { id = "nhdogjmejiglipccpnnnanhbledajbpd"; } # Vue devtools
        { id = "jabopobgcpjmedljpbcaablpmlmfcogm"; } # WhatFont
        { id = "gebbhagfogifgggkldgodflihgfeippi"; } # Return Youtube Dislike
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock'
        { id = "hkgfoiooedgoejojocmhlaklaeopbecg"; } # PiP
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      ];
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
        "--gtk-version=4"
        "--enable-vulkan"
        "--enable-features=SkiaGraphite"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder,VaapiVideoDecodeLinuxGL"
        "--enable-features=WebRTCPipeWireCapturer"
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
        # Nix stuff
        udd = "update-desktop-database ~/.local/share/applications";
        rb = "pushd ~/dotfiles && sudo nixos-rebuild switch --flake . && popd && udd";
        rbu = "pushd ~/dotfiles && nix flake update && sudo nixos-rebuild switch --flake . && popd && udd";
        nix-cleanup = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +5 && sudo nix-collect-garbage -d";

        # webdev
        up = "make up";
        upd = "make up.d";
        down = "make down";
      };
    };

    starship = {
      enable = true;
      settings = {
        add_newline = true;
      };
    };


    fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "nixos_small";
          padding = {
            right = 1;
          };
        };
        display = {
          size = {
            binaryPrefix = "si";
          };
          color = "blue";
          separator = "   ";
        };
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "display"
          "de"
          "wm"
          "terminal"
          {
            type = "cpu";
            format = "{1} ({3}) @ {7} GHz";
          }
          "gpu"
          "memory"
          "break"
          "colors"
        ];
      };
    };
  };


  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [ "gtk" ];
        };
        hyprland = {
          default = [ "hyprland" "gtk" ];
          "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        };
      };
    };
    configFile = (builtins.mapAttrs
      (name: subpath: {
        source = create_symlink "${dotfiles}/${subpath}";
        recursive = true;
      })
      configs) // {
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Catppuccin-Mocha-Blue
      '';
      "gtk-3.0/bookmarks".text = ''
        file:///home/${user}/Documents
        file:///home/${user}/Downloads
        file:///home/${user}/Music
        file:///home/${user}/Pictures
        file:///home/${user}/Videos
        file:///home/${user}/code
      '';
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      download = "$HOME/Downloads";
      documents = "$HOME/Documents";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
    };

    desktopEntries = {
      figma = {
        name = "Figma";
        exec = "${lib.getExe pkgs.brave} --app=https://www.figma.com";
        icon = "brave-browser";
        terminal = false;
        categories = [ "Graphics" ];
        settings = {
          StartupWMClass = "www.figma.com";
        };
      };

      linear = {
        name = "Linear";
        exec = "${lib.getExe pkgs.brave} --app=https://linear.app";
        icon = "brave-browser";
        terminal = false;
        categories = [ "Office" ];
        settings = {
          StartupWMClass = "linear.app";
        };
      };

      whatsapp = {
        name = "WhatsApp";
        exec = "${lib.getExe pkgs.brave} --app=https://web.whatsapp.com";
        icon = "brave-browser";
        terminal = false;
        categories = [ "Network" "Chat" ];
        settings = {
          StartupWMClass = "web.whatsapp.com";
        };
      };
    };
  };

  fonts.fontconfig.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = "Bibata-Modern-Classic";
      icon-theme = "Yaru";
    };
  };

  gtk = {
    enable = true;

    theme = {
      name = "catppuccin-mocha-blue-standard+black";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        variant = "mocha";
        tweaks = [ "black" ];
      };
    };

    iconTheme = {
      name = "Yaru";
      package = pkgs.yaru-theme;
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "kvantum"; # Kvantum handles OLED themes for QT best
  };



  services.blueman-applet.enable = true;


}
