{ pkgs, lib, ... }:

let
  pname = "tableplus";
  version = "latest";

  tableplus-app = pkgs.appimageTools.wrapType2 {
    inherit pname version;
    src = pkgs.fetchurl {
      url = "https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage";
      sha256 = "sha256-YpodFUjku3PUZ31lOy4kEpOJGUI3Smz8SRHUrGoIy2I=";
    };

    extraPkgs = pkgs: with pkgs; [
      libthai
      at-spi2-atk
      libsecret
    ];
  };

in
{
  home.packages = [ tableplus-app ];

  xdg.desktopEntries.tableplus = {
    name = "TablePlus";
    exec = "${tableplus-app}/bin/${pname}";
    icon = "${tableplus-app}/share/icons/hicolor/256x256/apps/tableplus.png";
    type = "Application";
    categories = [ "Development" "Database" ];
  };
}

