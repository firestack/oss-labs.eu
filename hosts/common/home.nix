{ config, pkgs, lib, ... }:

{
  programs = {
    bat = {
      enable = true;
    };
    command-not-found = {
      enable = lib.mkForce false;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    exa = {
      enable = true;
    };
    fish = {
      enable = true;
      plugins = [];
      shellAliases = {
        ll = "exa -lha";
        cat = "bat";
        ls = "exa";
      };
    };
    home-manager = {
      enable = true;
    };
    htop = {
      enable = true;
    };
  };
}
