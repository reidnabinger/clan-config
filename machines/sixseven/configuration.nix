# ----------------------------------------------------------------------------
# MACHINE: sixseven — System76 Bonobo WS (bonw15)
#
# PURPOSE: Complete NixOS configuration for sixseven
#
# HARDWARE:
#   CPU: Intel i9-14900HX (32 threads)
#   GPU: NVIDIA RTX 4090 Laptop (AD103M)
#   RAM: 64GB DDR5
#   Storage: Samsung 990 PRO 4TB + MKNSSD 2TB (internal)
#            → rpool (single, ~1.8TB) for system + hpool (mirror, ~1.8TB) for data
#
# DEV-NOTES:
#   - This file is auto-imported by Clan from machines/sixseven/
#   - Disk layout in disko.nix, hardware in hardware.nix
#   - Impermanence rolls back / on every boot; persist to /persist
#   - networking.hostId is required for ZFS — derived from machine-id
# ----------------------------------------------------------------------------
{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./hardware.nix
    ./disko.nix
    ./impermanence.nix
    ../../modules/common.nix
    ../../modules/nvidia-laptop.nix
    ../../modules/laptop-power.nix
    ../../modules/desktop-wayland.nix
    ../../modules/user-reid.nix
    ../../modules/dotfiles.nix
  ];

  # ---------------------------------------------------------------------------
  # Identity
  # ---------------------------------------------------------------------------
  networking.hostName = "sixseven";
  # DEV-NOTE: Required for ZFS. Derived from first 8 chars of machine-id.
  networking.hostId = "a09abb9a";

  # ---------------------------------------------------------------------------
  # Enable feature modules
  # ---------------------------------------------------------------------------
  my = {
    nvidia-laptop.enable = true;
    laptop-power.enable = true;
    desktop-wayland.enable = true;
    user-reid.enable = true;
    dotfiles.enable = true;
    dotfiles.users.reid = [ "nvim" ];
  };

  # ---------------------------------------------------------------------------
  # Neovim
  # ---------------------------------------------------------------------------
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # ---------------------------------------------------------------------------
  # Boot
  # ---------------------------------------------------------------------------
  boot = {
    kernelPackages = pkgs.linuxPackages;
    zfs.devNodes = "/dev/disk/by-id";
    supportedFilesystems = [ "zfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # ---------------------------------------------------------------------------
  # ZFS services
  # ---------------------------------------------------------------------------
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      frequent = 4; # every 15 min, keep 4
      hourly = 24;
      daily = 7;
      weekly = 4;
      monthly = 12;
    };
  };

  # ---------------------------------------------------------------------------
  # System state version — do not change after initial install
  # ---------------------------------------------------------------------------
  system.stateVersion = "25.11";
}
