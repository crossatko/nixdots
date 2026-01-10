{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr
      rocmPackages.rocblas
      rocmPackages.rocm-smi
      rocmPackages.hipblas
    ];
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.variables = {

    HSA_OVERRIDE_GFX_VERSION = "12.0.0";

    ROC_ENABLE_PRE_VEGA = "1";

    HIP_PATH = "${pkgs.rocmPackages.clr}";
  };

  environment.systemPackages = with pkgs; [

    opencode
    lmstudio

    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    clinfo
  ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
}
