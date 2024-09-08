{
  description = "Home Manager configuration Flake";

  inputs = {
    # Specify the source for Home Manager and Nixpkgs
    home-manager.url = "github:nix-community/home-manager/release-24.05"; 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { home-manager, nixpkgs, ... }:
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
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
