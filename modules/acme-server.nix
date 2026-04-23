{ config, lib, pkgs, ... }:
let
  caHost = "ca.home.johansson.io";
  caPort = 8443;
in
{
  environment.systemPackages = with pkgs; [
    step-cli
    step-ca
  ];

  sops.secrets = {
    "step-ca/intermediate_ca_key" = {
      owner = "step-ca";
      group = "step-ca";
      mode = "0400";
    };

    "step-ca/intermediate_ca_password" = {
      owner = "step-ca";
      group = "step-ca";
      mode = "0400";
    };
  };

  services.step-ca = {
    enable = true;

    address = "0.0.0.0";
    port = caPort;

    intermediatePasswordFile =
      config.sops.secrets."step-ca/intermediate_ca_password".path;

    settings = {
      root = "${./step-ca/root_ca.crt}";
      crt = "${./step-ca/intermediate_ca.crt}";
      key = config.sops.secrets."step-ca/intermediate_ca_key".path;  # your existing intermediate key, sops-managed
      address = ":${toString caPort}";
      dnsNames = [ caHost ];

      db = {
        type = "badgerv2";
        dataSource = "/var/lib/step-ca/db";
      };

      logger = {
        format = "text";
      };

      authority = {
        provisioners = [
          {
            type = "ACME";
            name = "acme";
          }
        ];
      };

      tls = {
        cipherSuites = [
          "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
          "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
        ];
        minVersion = 1.2;
        maxVersion = 1.3;
        renegotiation = false;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ caPort ];
}