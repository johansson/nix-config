{ config, pkgs, ... }:
{
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  sops.secrets.will-password-hash = {
    neededForUsers = true;
  };

  users.mutableUsers = false;

  users.users.will = {
    description = "Will Johansson";
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.will-password-hash.path;
    home = "/home/will";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtlyvXLVkT53PSNwaF2MDIpH9WaSuhOuKMKXnLWJjhC will@ingolstadt"
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
