{ pkgs, ... }:

{
  programs.bash.enable = true;

  programs.zsh = {
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
      nix-cleanup = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +5 && sudo nix-collect-garbage -d";
      ":q" = "exit";
      up = "make up";
      upd = "make up.d";
      down = "make down";
      killdocker = "docker kill $(docker ps -q)";
      kd = "docker kill $(docker ps -q)";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
    };
  };

  programs.fastfetch = {
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
        separator = "  ";
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
}
