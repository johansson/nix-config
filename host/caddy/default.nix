{ config, pkgs, ... }:
{
  sops.defaultSopsFile = ../../secrets/caddy.yaml;
  system.stateVersion = "25.11";
}