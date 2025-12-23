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
      "docker"
    ];
    shell = pkgs.zsh;
  };
}
