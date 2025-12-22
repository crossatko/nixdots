{ pkgs, inputs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "default";
        position = "top";
        outerCorners = true;
        widgets = { animationDisabled = true; };
      };
    };
  };
}
