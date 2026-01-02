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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  hardware.i2c.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    package = pkgs.mesa;
    extraPackages = with pkgs; [
      libva
      libva-utils
      rocmPackages.clr.icd
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];

  environment.systemPackages = with pkgs; [
    vulkan-tools
    clinfo
    pciutils
  ];
}
