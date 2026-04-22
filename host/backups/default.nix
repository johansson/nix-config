{ config, pkgs, ... }:
{
  sops.defaultSopsFile = ../../secrets/backups.yaml;
  sops.secrets.restic-htpasswd = {
    owner = "restic";
    group = "restic";
    mode = "0400";
  };

  services.restic.server = {
    enable = true;
    listenAddress = "0.0.0.0:8000";
    appendOnly = true;
    dataDir = "/srv/restic";
    extraFlags = [ "--htpasswd-file" config.sops.secrets.restic-htpasswd.path ];
  };

  networking.firewall.allowedTCPPorts = [ 8000 ];

  systemd.tmpfiles.rules = [
    "d /srv/restic 0750 restic restic -"
  ];

  system.stateVersion = "25.11";
}