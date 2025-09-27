{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";
    nix-alien.url = "github:thiagokokada/nix-alien";

    nixpkgs-memprocfs.url = "github:fqidz/nixpkgs/memprocfs";
    nixpkgs-dcpt510w.url = "github:fqidz/nixpkgs/brother-dcp-t510w-driver";

    monitor-wake = {
      url = "github:fqidz/monitor-wake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-memprocfs,
      nixpkgs-dcpt510w,
      home-manager,
      quadlet-nix,
      spicetify-nix,
      sops-nix,
      nix-index-database,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      username = "faidz";
    in
    {
      # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      nixosConfigurations = {
        "laptop" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs username;
            system = "x86_64-linux";
            pkgs-memprocfs = import nixpkgs-memprocfs {
              system = "x86_64-linux";
            };
            pkgs-dcpt510w = import nixpkgs-dcpt510w {
              system = "x86_64-linux";
            };
          };
          modules = [
            ./hosts/laptop/configuration.nix
            nix-index-database.nixosModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
            quadlet-nix.nixosModules.quadlet

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs outputs username;
                  system = "x86_64-linux";
                };

                users.${username}.imports = [
                  ./hosts/laptop/home.nix
                  spicetify-nix.homeManagerModules.spicetify
                  sops-nix.homeManagerModules.sops
                ];
              };
            }
          ];
        };

        "vps" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs outputs username;
            system = "aarch64-linux";
          };
          modules = [
            ./hosts/vps/configuration.nix
            nix-index-database.nixosModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
            quadlet-nix.nixosModules.quadlet

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs outputs username;
                  system = "aarch64-linux";
                };

                users.${username}.imports = [
                  ./hosts/vps/home.nix
                  sops-nix.homeManagerModules.sops
                ];
              };
            }
          ];
        };
      };

      homeConfigurations = {
        "${username}@laptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [
            nix-index-database.hmModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
          ];
        };

        "${username}@vps" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-linux";
          modules = [
            nix-index-database.hmModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
          ];
        };
      };
    };
}
