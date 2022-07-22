{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
      any-nix-shell
      bottom # https://zaiste.net/posts/shell-commands-rust/
      cachix
      du-dust
      fd
      fish
      git
      gnupg
      neofetch
      p7zip
      procs
      tig
      wget
    ];
}
