{ config, pkgs, ... }:
{
  sops.defaultSopsFile = ../../secrets/backups.yaml;
  system.stateVersion = "25.11";
}