{ config, pkgs, ... }:

{
  programs = {
    bat = {
      enable = true;
    };
    command-not-found = {
      enable = false;
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
      interactiveShellInit = ''
        any-nix-shell fish --info-right | source
      '';
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
