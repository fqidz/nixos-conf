{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-testing.url = "github:fqidz/nixpkgs/brother-dcp-t510w-driver";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = inputs@{ self, nixpkgs, nixpkgs-testing, home-manager, ... }: 
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        {
          nixpkgs.overlays = [
            (final: prev: {
              testing = import nixpkgs-testing {
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
            extraSpecialArgs = { inherit inputs; };

            users.faidz.imports = [
              inputs.spicetify-nix.homeManagerModules.default
              ./config/home.nix
            ];
          };
        }
      ];
    };
  };
}
