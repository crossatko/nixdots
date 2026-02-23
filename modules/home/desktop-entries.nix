{ config, pkgs, lib, ... }:

{
  xdg.desktopEntries = {
    figma = {
      name = "Figma";
      exec = "${lib.getExe pkgs.brave} --app=https://www.figma.com";
      icon = "brave-browser";
      terminal = false;
      categories = [ "Graphics" ];
      settings = {
        StartupWMClass = "www.figma.com";
      };
    };

    linear = {
      name = "Linear";
      exec = "${lib.getExe pkgs.brave} --app=https://linear.app";
      icon = "brave-browser";
      terminal = false;
      categories = [ "Office" ];
      settings = {
        StartupWMClass = "linear.app";
      };
    };

    whatsapp = {
      name = "WhatsApp";
      exec = "${lib.getExe pkgs.brave} --app=https://web.whatsapp.com";
      icon = "brave-browser";
      terminal = false;
      categories = [
        "Network"
        "Chat"
      ];
      settings = {
        StartupWMClass = "web.whatsapp.com";
      };
    };
  };
}
