{
  description = "Will Johansson's Personal Machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      sops-nix,
      ...
    }:
    {
      nixosConfigurations = {
        playground = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            ./configuration/proxmox-ct.nix
            ./host/default.nix
            ./host/playground
            ./modules/trust-home.johansson.io-root-ca.nix
          ];
        };

        backups = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            ./configuration/proxmox-ct.nix
            ./host/default.nix
            ./host/backups
            ./modules/trust-home.johansson.io-root-ca.nix
            ./modules/restic-server.nix
          ];
        };

        caddy = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            ./configuration/proxmox-ct.nix
            ./host/default.nix
            ./host/caddy
            ./modules/acme-server.nix
            ./modules/trust-home.johansson.io-root-ca.nix
            ./modules/caddy-from-sites.nix
          ];
        };

        testnix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            ./configuration/proxmox-ct.nix
            ./host/default.nix
            ./host/testnix
            ./modules/trust-home.johansson.io-root-ca.nix
          ];
        };
      };
    };
}
