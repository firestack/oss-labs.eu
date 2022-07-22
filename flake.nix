{
  description = "A NixOS flake for Pol's personal computer.";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    plasma-manager.url = "github:pjones/plasma-manager";

    # Fish theme
    bobthefish = { url = "github:oh-my-fish/theme-bobthefish"; flake = false; };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nixpkgs-unstable, ... }@inputs: 
    let
      overlay-unstable = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final) config;
          system = "x86_64-linux";
        };
      };
    in
    {
    nixosConfigurations = {
      hedgedoc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # disabledModules = [ "services/web-apps/hedgedoc.nix" ];
        modules = [
          ({ nixpkgs.overlays = [ 
             (final: prev: { bobthefish-src = inputs.bobthefish; }) 
             overlay-unstable
          ]; })
          (import ./hosts/hedgedoc/packages.nix)
          (import ./hosts/hedgedoc/configuration.nix)
          (import ./hosts/hedgedoc/postgres.nix)
          (import ./hosts/hedgedoc/hedgedoc.nix)
        ];
        specialArgs = inputs;
      };
    };
  } // inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [ nixpkgs-fmt nixfmt ];
      };
    }
  );
}

