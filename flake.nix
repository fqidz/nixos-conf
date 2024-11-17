{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-master,
      home-manager,
      sops-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "faidz";
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
        };
        modules = [
          {
            nixpkgs.overlays = [
              (final: prev: {
                master = import nixpkgs-master {
                  inherit system;
                  config.allowUnfree = true;
                };
              })
            ];
          }

          ./configuration.nix

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
    };
}
