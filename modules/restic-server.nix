{ config, pkgs, lib, ... }:
{
  sops.secrets.restic-htpasswd = {
    owner = "restic";
    group = "restic";
    mode = "0400";
  };

  sops.secrets.restic-repo-password = {
    owner = "root";
    group = "root";
    mode = "0400";
  };

  services.restic.server = {
    enable = true;
    listenAddress = "0.0.0.0:8000";
    appendOnly = true;
    dataDir = "/srv/restic";
    extraFlags = [ "--htpasswd-file" config.sops.secrets.restic-htpasswd.path ];
  };

  systemd.tmpfiles.rules = [
    "d /srv/restic 0750 restic restic -"
  ];

  networking.firewall.allowedTCPPorts = [ 8000 ];

  systemd.services.restic-prune-backfire = {
    description = "Prune restic backups for backfire-prod";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    path = [ pkgs.restic ];
    environment = {
      RESTIC_PASSWORD_FILE = config.sops.secrets.restic-repo-password.path;
      RESTIC_REPOSITORY = "/srv/restic/backfire-prod";
    };
    script = ''
      restic forget --prune \
        --keep-daily 14 \
        --keep-weekly 8 \
        --keep-monthly 12
    '';
  };

  systemd.timers.restic-prune-backfire = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun 04:00";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
  };
}
