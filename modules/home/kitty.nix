{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.8";
      dynamic_background_opacity = true;
      font_size = 20;
    };
    font.name = "ComicShannsMono Nerd Font";

  };

}
