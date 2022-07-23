{ config, pkgs, ... }:

{
  programs = {
    bat = {
      enable = true;
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
      plugins = [
        {
          name = "bobthefish";
          src = pkgs.bobthefish-src;
        }
      ];
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
