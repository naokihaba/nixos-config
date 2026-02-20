{
  description = "NixOS configuration with Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    "nix-darwin" = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      ...
    }:
    {
      darwinConfigurations."my-mac" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          (
            { pkgs, ... }:
            {
              environment.systemPackages = [ pkgs.git ];
              system.stateVersion = 6;
            }
          )
        ];
      };
    };
}
