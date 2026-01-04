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
    btop
    ffmpeg

    libappindicator-gtk3
    libdbusmenu-gtk3

    libnotify
    ddcutil

    tailscale
  ];

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib # glibc + core libs
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    systemd # Often needed
    glib
    libxml2
    util-linux
    attr
    acl
    bzip2
    xz
    zstd
    libssh
    libgcc
  ];

}
