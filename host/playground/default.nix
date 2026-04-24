{ config, pkgs, ... }:
{
  sops.defaultSopsFile = ../../secrets/playground.yaml;

  nix.settings.trusted-users = [ "root" "nixbuilder" ];
  nix.settings.max-jobs = "auto";
  nix.settings.cores = 0;
  nix.settings.download-buffer-size = 134217728;  # 128 MiB

  users.users.nixbuilder = {
    description = "Nix Builder";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtlyvXLVkT53PSNwaF2MDIpH9WaSuhOuKMKXnLWJjhC will@ingolstadt"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+pjTJKyF3TaQFdFLaBPyZaAYUtr/GcdpxXIwzmiCPv root@ingolstadt"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    nixfmt
    vim

    (vim.customize {
      name = "nixcfg";
      vimrcConfig.customRC = ''
        set number
        set relativenumber
        set tabstop=2
        set shiftwidth=2
        set softtabstop=2
        set expandtab
        syntax on
        set colorcolumn=80
      '';
      vimrcConfig.packages.plugins = with pkgs.vimPlugins; {
        start = [ vim-nix ];
      };
    })
  ];

  system.stateVersion = "25.11";
}