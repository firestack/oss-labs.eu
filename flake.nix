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
    deploy-rs.url = "github:serokell/deploy-rs";

    # Fish theme
    bobthefish = { url = "github:oh-my-fish/theme-bobthefish"; flake = false; };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nixpkgs-unstable, deploy-rs, ... }@inputs:
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
          (import ./hosts/pad.oss-labs.eu/packages.nix)
          (import ./hosts/pad.oss-labs.eu/configuration.nix)
          (import ./hosts/pad.oss-labs.eu/postgres.nix)
          (import ./hosts/pad.oss-labs.eu/hedgedoc.nix)
        ];
        specialArgs = inputs;
      };
    };
  } // {
      deploy.nodes.oss-labs = {
        hostname = "ec2-34-242-86-57.eu-west-1.compute.amazonaws.com";
        fastConnection = true;
        profiles = {
          hedgedoc = {
            sshUser = "root";
            path =
              deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hedgedoc;
            user = "root";
          };
        };
      };
  } //inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      devShells = {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ nixpkgs-fmt nixfmt ];
        };
      };

    }
  );
}

