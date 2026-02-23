{ pkgs, ... }:

{
  programs.brave = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; }
      { id = "nhdogjmejiglipccpnnnanhbledajbpd"; }
      { id = "jabopobgcpjmedljpbcaablpmlmfcogm"; }
      { id = "gebbhagfogifgggkldgodflihgfeippi"; }
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
      { id = "hkgfoiooedgoejojocmhlaklaeopbecg"; }
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
    ];
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=UseOzonePlatform:Wayland"
      "--disable-features=WaylandWpColorManagerV1"
      "--enable-vulkan"
    ];
  };

  programs.firefox.enable = true;
}
