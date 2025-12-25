{ pkgs, ... }:
{
  users.users.kreejzak = {
    isNormalUser = true;
    description = "Paul Cross";
    extraGroups = [
      "networkmanager"
      "wheel"
      "render"
      "video"
      "i2c"
      "docker"
    ];
    shell = pkgs.zsh;
  };
}
