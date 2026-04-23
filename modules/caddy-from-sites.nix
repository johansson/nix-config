{ config, lib, pkgs, ... }:
let
  httpPort = 80;
  httpsPort = 443;
  
  sitesFile = import ./home.johansson.io.nix;
  inherit (sitesFile) domain sites;

  caddySites = lib.filterAttrs (_: s: s ? caddy) sites;
  mkVhost = _: s: lib.nameValuePair "${s.subdomain}.${domain}" {
    extraConfig = ''
      reverse_proxy ${s.caddy.upstreamHost}:${toString s.caddy.upstreamPort} {
        ${s.caddy.extra or ""}
      }
    '';
  };

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

    virtualHosts = (lib.mapAttrs' mkVhost caddySites) // {
      "${domain}" = {
        extraConfig = ''
          root * ${landing}
          file_server
        '';
      };
    };
  };
}