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

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";
    nix-alien.url = "github:thiagokokada/nix-alien";

    nixpkgs-graalvm-ce-21.url = "github:nixos/nixpkgs/27ec1c9b87f5906fcf94c1e7b2c50ca6c0fc8de5";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-graalvm-ce-21,
      home-manager,
      sops-nix,
      nix-index-database,
      nix-alien,
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
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      # nixosModules = import ./modules/nixos;
      # homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        "laptop" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs username;
            system = "x86_64-linux";
          };
          modules = [
            ./hosts/laptop/configuration.nix
            nix-index-database.nixosModules.nix-index
            { programs.nix-index-database.comma.enable = true; }

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs outputs username;
                  pkgs-graalvm-ce-21 = import nixpkgs-graalvm-ce-21 {
                    system = "x86_64-linux";
                  };
                  system = "x86_64-linux";
                };

                users.${username}.imports = [
                  ./hosts/laptop/home.nix
                  inputs.spicetify-nix.homeManagerModules.spicetify
                  inputs.sops-nix.homeManagerModules.sops
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
                  # inputs.sops-nix.homeManagerModules.sops
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
