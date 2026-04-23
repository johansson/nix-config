{ config, pkgs, ... }:
{
  sops.defaultSopsFile = ../../secrets/testnix.yaml;
  system.stateVersion = "25.11";
}