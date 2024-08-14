{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    stylix.url = "github:danth/stylix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, stylix, home-manager,  ...  }: {
   # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
   # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    nixosConfigurations.sert = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ stylix.nixosModules.stylix 
		./configuration.nix 
		home-manager.nixosModules.home-manager
		];
    };
  };
}
