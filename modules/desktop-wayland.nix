# ----------------------------------------------------------------------------
# MODULE: Wayland desktop environment
#
# PURPOSE: SDDM display manager + basic Wayland session support
#
# DEV-NOTES:
#   - SDDM with Wayland greeter
#   - Does not prescribe a compositor — machine config can add Niri, Sway, etc.
#   - XDG portal for screen sharing, file dialogs
# ----------------------------------------------------------------------------
{ config, lib, pkgs, ... }:
let
  cfg = config.my.desktop-wayland;
in
{
  options.my.desktop-wayland.enable = lib.mkEnableOption "Wayland desktop with SDDM";

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    # DEV-NOTE: Pipewire for audio — required by most Wayland compositors
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      wl-clipboard
      foot          # terminal
      wofi          # launcher
      mako          # notifications
      grim          # screenshot
      slurp         # region select
    ];
  };
}
