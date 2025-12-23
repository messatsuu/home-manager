{
  description = "A simple NixOS flake for system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    zen-browser.url = "github:messatsuu/zen-browser-flake";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # TODO: is this needed?
    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      # Prevents mismatch
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-overlay = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
      ];
    };
  };
}
