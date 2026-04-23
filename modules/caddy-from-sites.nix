{ config, lib, pkgs, ... }:
let
  httpPort = 80;
  httpsPort = 443;
  
  sitesFile = import ./home.johansson.io.nix;
  inherit (sitesFile) domain sites;

  caddySites = lib.filterAttrs (_: s: s ? caddy) sites;

  mkVhosts = _: s: [
    # Bare subdomain, redirect to FQDN
    (lib.nameValuePair s.subdomain {
      extraConfig = ''
        redir https://${s.subdomain}.${domain}{uri} permanent
      '';
    })

    # FQDN to reverse proxy
    (lib.nameValuePair "${s.subdomain}.${domain}" {
      extraConfig = ''
        reverse_proxy ${s.caddy.upstreamHost}:${toString s.caddy.upstreamPort} {
          ${s.caddy.extra or ""}
        }
      '';
    })
  ];

  caddyVhosts = lib.listToAttrs
    (lib.flatten
      (lib.mapAttrsToList mkVhosts caddySites));

  landing = pkgs.callPackage ./landing-page {
    inherit sites domain;
  };
in
{
  users.users.will.extraGroups = [ "caddy" ];
  networking.firewall.allowedTCPPorts = [ httpPort httpsPort ];
  services.caddy = {
    enable = true;
    email = "will@johansson.io";

    globalConfig = ''
      acme_ca https://ca.home.johansson.io:8443/acme/acme/directory
    '';

    virtualHosts = caddyVhosts // {
      "${domain}" = {
        extraConfig = ''
          root * ${landing}
          file_server
        '';
      };
    };
  };
}