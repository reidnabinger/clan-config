# ----------------------------------------------------------------------------
# MODULE: Common base configuration for all machines
#
# PURPOSE: Shared settings applied to every machine in the fleet
#
# DEV-NOTES:
#   - Import this in every machine's configuration.nix
#   - Keep this minimal — only truly universal settings
#   - Machine-specific overrides go in the machine's own config
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    htop
    btop
    tree
    ripgrep
    fd
    jq
    tmux
    zsh
    pciutils
    usbutils
    lshw
    smartmontools
    zip
    unzip
    p7zip
  ];

  services.tailscale.enable = true;

  programs.nix-ld.enable = true;
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;
}
