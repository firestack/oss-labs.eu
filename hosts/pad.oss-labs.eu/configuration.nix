{ modulesPath, pkgs, lib, config, ... }:

{
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  ec2.hvm = true;

  networking.hostName = "hedgedoc";
  time.timeZone = "Europe/Brussels";

  users.users.root.shell = pkgs.fish;

  system.stateVersion = "22.05";
  environment.noXlibs = lib.mkForce false;
  networking.firewall.allowedTCPPorts = [
    22
    config.services.hedgedoc.settings.port
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    settings = {
      trusted-users = [ "root" "pol" ];
      auto-optimise-store = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:drupol/oss-labs.eu";
    allowReboot = false;
  };
}
