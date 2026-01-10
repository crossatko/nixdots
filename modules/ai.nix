{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "12.0.0";
  };

  services.open-webui = {
    enable = true;
    port = 8080;
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      WEBUI_AUTH = "False";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];

  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    (btop.override { rocmSupport = true; })
    lmstudio
    opencode
  ];
}
