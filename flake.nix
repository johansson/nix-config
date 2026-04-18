{
  description = "Will Johansson's Personal Machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      ...
    }:
    {
      nixosConfigurations = {
        playground = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration/proxmox-ct.nix
            ./host/default.nix
            ./host/playground
          ];
        };

        # Add future hosts here
      };
    };
}
