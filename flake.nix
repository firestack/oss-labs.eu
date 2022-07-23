{
  description = "A NixOS flake for OSS Labs servers.";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Fish theme
    bobthefish = { url = "github:oh-my-fish/theme-bobthefish"; flake = false; };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nixpkgs-unstable, deploy-rs, ... }@inputs:
    {
      nixosConfigurations = {
        hedgedoc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import ./hosts/common/config.nix)
            ({
              nixpkgs.overlays = [
                (final: prev: { bobthefish-src = inputs.bobthefish; })
              ];
            })
            (import ./hosts/pad.oss-labs.eu/configuration.nix)
            (import ./hosts/pad.oss-labs.eu/packages.nix)
            (import ./hosts/pad.oss-labs.eu/postgres.nix)
            (import ./hosts/pad.oss-labs.eu/hedgedoc.nix)
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.root.imports = [
                ./hosts/common/home.nix
                { home.stateVersion = "22.05"; }
              ];
            }

          ];
          specialArgs = inputs;
        };
      };
    } // {
      deploy.nodes.hedgedoc = {
        hostname = "ec2-18-202-250-170.eu-west-1.compute.amazonaws.com";
        fastConnection = true;
        profiles = {
          system = {
            sshUser = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hedgedoc;
            user = "root";
          };
        };
      };
    } // inputs.flake-utils.lib.eachDefaultSystem (system:
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

