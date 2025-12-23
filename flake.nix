{
  description = "CrossFlake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland?submodules=1";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , hyprland
    , nix-flatpak
    , ...
    }@inputs:
    {
      nixosConfigurations.CrossBattlestation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/CrossBattlestation/configuration.nix
          ./modules/hyprland.nix
          ./modules/gaming.nix
          ./modules/flatpak.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.kreejzak = import ./home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };

      nixosConfigurations.NixVM = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/NixVM/configuration.nix
          ./modules/hyprland.nix
          ./modules/flatpak.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.kreejzak = import ./home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
}
