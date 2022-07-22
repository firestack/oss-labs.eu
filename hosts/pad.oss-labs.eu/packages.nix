{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
      bottom # https://zaiste.net/posts/shell-commands-rust/
      cachix
      du-dust
      fd
      fish
      git
      gnupg
      procs
      wget
    ];
}
