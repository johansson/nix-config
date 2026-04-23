{
  domain = "home.johansson.io";

  sites = {
    unifi = {
      subdomain = "unifi";

      landing = {
        label = "Unifi Cloud Gateway Max";
        description = "Router";
        category = "network";
      };
    };

    proxmox = {
      subdomain = "proxmox01";
      port = 8006;

      landing = {
        label = "Proxmox";
        description = "Container and VM host";
        category = "infra";
      };
    };

    aptCache = {
      subdomain = "apt-cache";

      caddy = {
        upstreamHost = "172.16.0.199";
        upstreamPort = 3142;
      };

      landing = {
        label = "Apt-Cacher NG";
        description = "Debian package cache";
        category = "infra";
        path = "/acng-report.html";
      };
    };

    paperless = {
      subdomain = "docs";

      caddy = {
        upstreamHost = "172.16.0.102";
        upstreamPort = 8000;
      };

      landing = {
        label = "Paperless";
        description = "Document archive";
        category = "apps";
      };
    };
  };
}

#   # Opt-out example — vhost exists, but hidden from landing page
#   prometheus = {
#    subdomain = "metrics";
#    upstream = "10.20.0.30:9090";
#    landing.show = false;
#   };

#   homeAssistant = {
#     caddy = {
#       subdomain = "ha";
#       upstream = "10.20.0.40:8123";
#     };

#     landing = {
#       label = "Home Assistant";
#       description = "Home automation";
#       category = "apps";
#     };
#   };

#   grafana = {
#     caddy = {
#       subdomain = "grafana";
#       upstream = "10.20.0.30:3000";
#     };

#     landing = {
#       label = "Grafana";
#       description = "Dashboards";
#       category = "monitoring";
#     };
#   };
# }