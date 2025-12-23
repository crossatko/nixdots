{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix
  ../shared/boot.nix 
  ../shared/language-time.nix
  ../shared/system.nix
  ../shared/user.nix
  ../shared/programs.nix

  ];

  networking.hostName = "NixVM"; # Define your hostname.
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
}
