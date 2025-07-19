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
    inputs@{
      nixpkgs,
      nixpkgs-graalvm-ce-21,
      home-manager,
      sops-nix,
      nix-index-database,
      nix-alien,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "faidz";
      pkgs = nixpkgs.legacyPackages.x86_64-linux.${system};
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;
      nixosConfigurations = {
        "default" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs username system;
          };
          modules = [
            ./configuration.nix
            nix-index-database.nixosModules.nix-index
            { programs.nix-index-database.comma.enable = true; }

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs username;
                  pkgs-graalvm-ce-21 = import nixpkgs-graalvm-ce-21 {
                    inherit system;
                  };
                };

                users.${username}.imports = [
                  ./config/home.nix
                  inputs.spicetify-nix.homeManagerModules.default
                  inputs.sops-nix.homeManagerModules.sops
                ];
              };
            }
          ];
        };
        homeConfigurations = {
          "faidz" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [
              nix-index-database.hmModules.nix-index
              { programs.nix-index-database.comma.enable = true; }
            ];
          };
        };
      };
    };
}
