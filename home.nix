{ pkgs, lib, ... }:

{
  home.username = "naokihaba";
  home.homeDirectory = lib.mkForce "/Users/naokihaba";

  home.packages = [
    pkgs.git
  ];

  home.stateVersion = "24.11";
}
