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

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  services.resolved = {
    enable = true;
    domains = [ "home.johansson.io" ];
    extraConfig = ''
      Cache=true
      CacheFromLocalhost=true
    '';
  };

  services.fstrim.enable = false;
}
