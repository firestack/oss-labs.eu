{ config, pkgs, lib, ... }:

{
  boot.cleanTmpDir = true;

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';

  # Nix Settings
  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
    };
  };
}
