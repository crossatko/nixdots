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

  services.dbus.enable = true;
  services.udev.enable = true;

  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  services.gnome.tinysparql.enable = true;
  services.gnome.localsearch.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.samba.openFirewall = true;
  services.samba.nsswins = true;

  services.tailscale.enable = true;
}
