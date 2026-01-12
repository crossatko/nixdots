{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/services.nix
    ../shared/language-time.nix
    ../shared/system.nix
    ../shared/user.nix
    ../shared/programs.nix
  ];
  boot = {

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelModules = [ "snd-aloop" ];

    initrd = {
      kernelModules = [ "amdgpu" ];

      luks.devices."luks-e2d7e961-ee37-4c99-8495-da1295db1ee1".device =
        "/dev/disk/by-uuid/e2d7e961-ee37-4c99-8495-da1295db1ee1";
    };

  };
  networking = {

    hostName = "CrossWorkstation"; # Define your hostname.

    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 53317 ];
    firewall.allowedUDPPorts = [ 53317 ];
  };

  hardware = {

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true; # Helps with battery info and some headset features
        };
      };
    };
    i2c.enable = true;

    graphics = {
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
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    clinfo
    pciutils
  ];
}
