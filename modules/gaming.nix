{ pkgs, ... }:

{
  hardware.steam-hardware.enable = true;
  boot.kernelModules = [ "hid-playstation" ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    gamemode
    gamescope
    protonplus
  ];

}
