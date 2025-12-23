{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/boot.nix
    ../shared/services.nix
    ../shared/language-time.nix
    ../shared/system.nix
    ../shared/user.nix
    ../shared/programs.nix

  ];

  networking.hostName = "CrossBattlestation";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
}
