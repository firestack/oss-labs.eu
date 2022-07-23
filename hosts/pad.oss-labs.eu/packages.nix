{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    any-nix-shell
    git
  ];
}
