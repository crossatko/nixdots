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

  boot.resumeDevice = "/dev/mapper/luks-e9e4b34e-873b-41da-85c5-da16ad7c17c1";

  boot.kernelParams = [
    "resume=/dev/mapper/luks-e9e4b34e-873b-41da-85c5-da16ad7c17c1"
    "pcie_aspm=off"
  ];

  boot.initrd.luks.devices."luks-e9e4b34e-873b-41da-85c5-da16ad7c17c1".device = "/dev/disk/by-uuid/e9e4b34e-873b-41da-85c5-da16ad7c17c1";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  powerManagement.enable = true;

  hardware.enableAllFirmware = true;

  networking.hostName = "CrossBattlestation";
  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  hardware.i2c.enable = true;

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };

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

  environment.systemPackages = with pkgs; [
    vulkan-tools
    clinfo
    pciutils
  ];
}
