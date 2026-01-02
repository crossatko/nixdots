{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../shared/services.nix
      ../shared/language-time.nix
      ../shared/system.nix
      ../shared/user.nix
      ../shared/programs.nix
    ];


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-e2d7e961-ee37-4c99-8495-da1295db1ee1".device = "/dev/disk/by-uuid/e2d7e961-ee37-4c99-8495-da1295db1ee1";
  networking.hostName = "CrossWorkstation"; # Define your hostname.

  networking.networkmanager.enable = true;
}
