{ modulesPath, pkgs, lib, config, profile, ... }:

{
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  ec2.hvm = true;

  networking.hostName = profile;
  time.timeZone = "Europe/Brussels";

  users.users.root.shell = pkgs.fish;

  system.stateVersion = "22.05";

  networking.firewall.allowedTCPPorts = [
    22
    config.services.hedgedoc.settings.port
  ];
}
