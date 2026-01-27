{
  description = "CrossFlake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland?submodules=1";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    wivrn.url = "github:WiVRn/WiVRn/v25.12";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      hyprland,
      nix-flatpak,
      nur,
      ...
    }@inputs:
    {
      nixosConfigurations.CrossBattlestation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          (
            { config, pkgs, ... }:
            {
              environment.variables = {
                HOST_CROSS_BATTLESTATION = "1";
                QT_QPA_PLATFORM = "xcb";
                SDL_VIDEODRIVER = "wayland";
                RADV_PERFTEST = "nggc";
                VKD3D_CONFIG = "dxr11";
                AMD_VULKAN_ICD = "RADV";
              };
            }
          )

          ./hosts/CrossBattlestation/configuration.nix
          ./modules/hyprland.nix
          ./modules/gaming.nix
          ./modules/flatpak.nix
          ./modules/ai.nix

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

      nixosConfigurations.CrossWorkstation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          (
            { config, pkgs, ... }:
            {
              environment.variables = {
                HOST_CROSS_WORKSTATION = "1";
              };
            }
          )

          ./hosts/CrossWorkstation/configuration.nix
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

      nixosConfigurations.NixVM = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          (
            { config, pkgs, ... }:
            {
              environment.variables = {
                HOST_NIX_VM = "1";
              };
            }
          )

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
