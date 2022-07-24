{ config, inputs, pkgs, ... }:

{
  imports = [
    ./config.nix
    ./home.nix
  ];
}
