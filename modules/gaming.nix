{
  pkgs,
  ...
}:
{
  services = {
    wivrn = {
      enable = true;
      openFirewall = true;

      defaultRuntime = true;

      autoStart = true;

    };

    # udev.extraRules = ''
    #   KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
    # '';
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  hardware.steam-hardware.enable = true;
  boot.kernelModules = [
    "hid-playstation"
    "uinput"
  ];

  boot.kernelPatches = [
    {
      name = "amdgpu-ignore-ctx-privileges";
      patch = pkgs.fetchpatch {
        name = "cap_sys_nice_begone.patch";
        url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
        hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
      };
    }
  ];

  environment.systemPackages = with pkgs; [
    mangohud
    gamescope
    protonplus
    bs-manager
    sidequest
    ffmpeg
  ];
  programs = {

    alvr = {
      enable = true;
      openFirewall = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = [
          "-w"
          "2560"
          "-h"
          "1440"
          "-W"
          "2560"
          "-H"
          "1440"
          "-O"
          "DP-2"
          "--adaptive-sync"
          "--hdr-enabled"
          "-f"
          "-e"
        ];
      };
    };
    gamemode.enable = true;

    nix-ld.enable = true;

    nix-ld.libraries = with pkgs; [
      libva
      ffmpeg

      libva
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
}
