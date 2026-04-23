{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

  boot.isContainer = true;

  # Remove if not working...
  # nix.settings.sandbox = false;

  proxmoxLXC = {
    manageNetwork = false;
    privileged = false;
  };

  networking.nameservers = [ "10.1.0.2" ];
  networking.search = [ "home.johansson.io" ];
  networking.useNetworkd = true;

  systemd.network.enable = true;
  systemd.services.systemd-networkd-wait-online.enable = true;

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  services.resolved = {
    enable = true;
    extraConfig = ''
      Cache=true
      CacheFromLocalhost=true
    '';
  };

  services.fstrim.enable = false;
}
