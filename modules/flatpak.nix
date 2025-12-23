{ pkgs, inputs, ... }: {

  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "com.discordapp.Discord"
      "org.localsend.localsend_app"
      "com.bambulab.BambuStudio"
      "com.obsproject.Studio"
      "org.signal.Signal"
    ];
    update.onActivation = true;
  };

  fonts.fontDir.enable = true;

}
