{
  pkgs,
  config,
  inputs,
  ...
}:
{
  hardware.steam-hardware.enable = true;
  boot.kernelModules = [ "hid-playstation" ];

  # Keep this if you have AMD GPU → helps with CAP_SYS_NICE / async reprojection
  boot.kernelPatches = [
    {
      name = "amdgpu-ignore-ctx-privileges";
      patch = pkgs.fetchpatch {
        name = "cap_sys_nice_begone.patch";
        url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
        hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo="; # verify if still valid for your kernel
      };
    }
  ];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true; # Helps Steam Link discovery

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
  };

  environment.systemPackages = with pkgs; [
    mangohud
    gamescope
    protonplus
    bs-manager

    # Keep opencomposite if you ever want to test bypassing SteamVR compositor (optional)
    # But for pure SteamVR → you can remove it later
    opencomposite
  ];

  # === CRITICAL: DISABLE WiVRn completely ===
  services.wivrn = {
    enable = false; # ← Change to false
    # Remove or comment out the rest of this block
    # openFirewall = true;
    # defaultRuntime = true;
    # package = ...;
  };

  # If you ever had services.monado = { ... }; → also set enable = false;
}
