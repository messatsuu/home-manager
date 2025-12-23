{
  description = "Home Manager configuration Flake";

  inputs = {
    # Use nixos-unstable for both nixpkgs and home-manager
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { home-manager, nixpkgs, ... } @inputs:
    let
      system = "x86_64-linux";
      custom-overlay = import ./custom-nix-packages/overlay.nix;
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ custom-overlay ];
      };
    in {
      homeConfigurations.nicolas = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
}
