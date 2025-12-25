{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "kreejzak" ];
  };

  environment.etc."1password/custom_allowed_browsers".text = ''
    brave
    brave-browser
  '';

  programs.zsh.enable = true;
  programs.bash.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    vim
    killall

    libappindicator-gtk3
    libdbusmenu-gtk3

    libnotify
    ddcutil
  ];
}
