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

    # spicetify-nix = {
    #   url = "github:Gerg-L/spicetify-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    sops-nix.url = "github:Mic92/sops-nix";
    nix-alien.url = "github:thiagokokada/nix-alien";

    nixpkgs-dcpt510w.url = "github:fqidz/nixpkgs/brother-dcp-t510w-driver";

    monitor-wake = {
      url = "github:fqidz/monitor-wake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flatpaks.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      quadlet-nix,
      # spicetify-nix,
      sops-nix,
      nix-index-database,
      flatpaks,
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
      overlays = {
        nixpkgs.overlays = [
          (final: prev:
          let
            memprocfs-derivation = prev.fetchFromGitHub {
              owner = "fqidz";
              repo = "nixpkgs";
              rev = "memprocfs";
              sha256 = "sha256-5K13nxAeSXl0Uy5c2jLP8Ou6+cYtn7To1q9iyGTdjnE=";
            };
          in
          {
            dcpt510w = final.callPackage "${
              prev.fetchFromGitHub {
                owner = "fqidz";
                repo = "nixpkgs";
                rev = "brother-dcp-t510w-driver";
                sha256 = "sha256-l3iAmAbmQu9vqdEclZ/q1a40e50zK21am6Ay6x5V/GY=";
              }
            }/pkgs/by-name/dc/dcpt510w/package.nix" { };

            leechcore-plugins =
              final.callPackage "${memprocfs-derivation}/pkgs/by-name/le/leechcore-plugins/package.nix" { };
            leechcore =
              final.callPackage "${memprocfs-derivation}/pkgs/by-name/le/leechcore/package.nix" { };
            memprocfs =
              final.callPackage "${memprocfs-derivation}/pkgs/by-name/me/memprocfs/package.nix" { };

            libfprint = prev.libfprint.overrideAttrs(oldAttrs: {
              version = "master";
              src = prev.fetchFromGitLab {
                domain = "gitlab.freedesktop.org";
                owner = "topni1";
                repo = "libfprint";
                rev = "master";
                hash = "sha256-91vOQLwIJ/p+WZgE+NOdPl6L8c97S65SCzWVr7qkt10=";
              };
              buildInputs = oldAttrs.buildInputs ++ [ prev.pkgs.nss ];
            });

            # fprintd = final.callPackage "${
            #   prev.fetchFromGitHub {
            #     owner = "NixOS";
            #     repo = "nixpkgs";
            #     rev = "ec5881151cfe27e080d7a3e8f25672d83c0a1f44";
            #     sha256 = "sha256-5FMuorBuIyxxa+bIPPKSlqOuV0ISUQfzBjyujqOQjvg=";
            #   }
            # }/pkgs/by-name/fp/fprintd/package.nix" { };

            calibre = final.callPackage "${
              prev.fetchFromGitHub {
                owner = "NixOS";
                repo = "nixpkgs";
                rev = "3428d5442b9b5c3772c496cbbaf8ba52d86ef667";
                sha256 = "sha256-XwltZhJ6wH1RrsScO4TvIjtP09PaBcc1NvyoWew4U6s=";
              }
            }/pkgs/by-name/ca/calibre/package.nix" { };
          })
        ];
      };
    in
    {
      # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

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
            quadlet-nix.nixosModules.quadlet

            overlays
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
                  # spicetify-nix.homeManagerModules.spicetify
                  sops-nix.homeManagerModules.sops
                  flatpaks.homeManagerModules.nix-flatpak
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
