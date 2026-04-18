{ config, pkgs, ... }:
{
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  users.users.will = {
    description = "Will Johansson";
    isNormalUser = true;
    hashedPasswordFile = "/etc/nixos/will.hashedPassword";
    home = "/home/will";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtlyvXLVkT53PSNwaF2MDIpH9WaSuhOuKMKXnLWJjhC will@ingolstadt"
    ];
  };

  environment.systemPackages = with pkgs; [
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
