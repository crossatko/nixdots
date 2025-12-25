{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/services.nix
    ../shared/language-time.nix
    ../shared/system.nix
    ../shared/user.nix
    ../shared/programs.nix

  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableAllFirmware = true;

  boot.initrd.luks.devices."luks-e9e4b34e-873b-41da-85c5-da16ad7c17c1".device = "/dev/disk/by-uuid/e9e4b34e-873b-41da-85c5-da16ad7c17c1";

  networking.hostName = "CrossBattlestation";
  networking.networkmanager.enable = true;


  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
