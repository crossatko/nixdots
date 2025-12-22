{ pkgs, inputs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "default";
        position = "top";
        outerCorners = false;
        widgets = { animationDisabled = true; };
      };
    };
  };
}
