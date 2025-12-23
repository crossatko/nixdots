{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    sushi
  ];

  # gnome virtual filesystem for trash etc
  services.gvfs.enable = true;

  # thumbnails in nautilus
  services.tumbler.enable = true;

  # allow connecting usbs in nautilus
  services.udisks2.enable = true;

}
