{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-fork.url = "github:fqidz/nixpkgs/calibre-downgrade";

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
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-fork,
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
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit system;
        };
        modules = [
          {
            nixpkgs.overlays = [
              (final: prev: {
                fork = import nixpkgs-fork {
                  inherit system;
                  config.allowUnfree = true;
                };
              })
            ];
          }

          ./configuration.nix
          nix-index-database.nixosModules.nix-index
          { programs.nix-index-database.comma.enable = true; }

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
                inherit username;
                inherit self;
              };

              users.${username}.imports = [
                inputs.spicetify-nix.homeManagerModules.default
                inputs.sops-nix.homeManagerModules.sops
                ./config/home.nix
              ];
            };
          }
        ];
      };
      homeConfigurations.faidz = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          nix-index-database.hmModules.nix-index
          { programs.nix-index-database.comma.enable = true; }
        ];
      };
    };
}
