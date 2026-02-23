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
  boot = {
    loader = {

      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };

    initrd.kernelModules = [ "amdgpu" ];

    resumeDevice = "/dev/mapper/luks-e9e4b34e-873b-41da-85c5-da16ad7c17c1";

    kernelParams = [
      "resume=/dev/mapper/luks-e9e4b34e-873b-41da-85c5-da16ad7c17c1"
      "pcie_aspm=off"
    ];

    initrd.luks.devices."luks-e9e4b34e-873b-41da-85c5-da16ad7c17c1".device =
      "/dev/disk/by-uuid/e9e4b34e-873b-41da-85c5-da16ad7c17c1";
    kernelPackages = pkgs.linuxPackages_latest;
  };

  powerManagement.enable = true;

  hardware = {
    enableAllFirmware = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    i2c.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };
  };

  networking = {
    hostName = "CrossBattlestation";
    networkmanager.enable = true;

    firewall.allowedTCPPorts = [ 53317 ];
    firewall.allowedUDPPorts = [ 53317 ];
  };
}
