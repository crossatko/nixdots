{ pkgs, config, ... }:

{
  hardware.steam-hardware.enable = true;
  boot.kernelModules = [ "hid-playstation" ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraPackages = [
      pkgs.gamemode
    ];
  };

  environment.systemPackages = with pkgs; [
    mangohud
    gamemode
    gamescope
    protonplus
    bs-manager
    opencomposite
  ];

  systemd.paths.steamvr-fix = {
    description = "Watch SteamVR launcher for changes";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      # Watch for changes to the file (e.g. Steam update)
      PathChanged = "/home/kreejzak/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
    };
  };

  systemd.services.steamvr-fix = {
    description = "Apply CAP_SYS_NICE to SteamVR for AMDGPU Async Reprojection";
    path = [ pkgs.libcap ]; # Provides the setcap binary

    script = ''
      TARGET="/home/kreejzak/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher"
      if [ -f "$TARGET" ]; then
        echo "Applying CAP_SYS_NICE to SteamVR..."
        setcap CAP_SYS_NICE+ep "$TARGET"
      fi
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "root"; # REQUIRED: Only root can set capabilities
    };
  };

  programs.alvr.enable = true;
  programs.alvr.openFirewall = true;

  home-manager.users.kreejzak = {
    xdg.enable = true;
    xdg.configFile."openxr/1/active_runtime.json" = {
      force = true;
      text = ''
        {
          "file_format_version" : "1.0.0",
          "runtime" : {
            "VALVE_runtime_is_steamvr" : true,
            "library_path" : "/home/kreejzak/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrclient.so",
            "name" : "SteamVR"
          }
        }
      '';
    };
  };


}


