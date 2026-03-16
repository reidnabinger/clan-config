# ----------------------------------------------------------------------------
# MODULE: NVIDIA laptop GPU configuration
#
# PURPOSE: Configure NVIDIA GPU as primary driver on laptops
#
# DEV-NOTES:
#   - Uses latest proprietary driver (closed source)
#   - Power management enabled for laptop battery life
#   - 32-bit GL libraries for Steam/Wine compatibility
#   - For VFIO passthrough on desktops, use a separate module
# ----------------------------------------------------------------------------
{ config, lib, pkgs, ... }:
let
  cfg = config.my.nvidia-laptop;
in
{
  options.my.nvidia-laptop.enable = lib.mkEnableOption "NVIDIA laptop GPU driver stack";

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
    ];
  };
}
