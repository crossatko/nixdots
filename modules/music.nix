{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.pipewire.jack.enable = true;

  environment.systemPackages = with pkgs; [
    zrythm
    audacity
  ];
}
