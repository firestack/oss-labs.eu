{ config, inputs, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./packages.nix
    ./hedgedoc.nix
    ./postgres.nix
  ];
}
