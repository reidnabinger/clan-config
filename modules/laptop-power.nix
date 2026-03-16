# ----------------------------------------------------------------------------
# MODULE: Laptop power management
#
# PURPOSE: Thermals, power profiles, lid switch behavior
#
# DEV-NOTES:
#   - power-profiles-daemon for runtime switching (power-saver/balanced/performance)
#   - thermald for Intel thermal management
#   - fwupd for firmware updates (System76 BIOS/EC)
# ----------------------------------------------------------------------------
{ config, lib, pkgs, ... }:
let
  cfg = config.my.laptop-power;
in
{
  options.my.laptop-power.enable = lib.mkEnableOption "Laptop power management";

  config = lib.mkIf cfg.enable {
    services.power-profiles-daemon.enable = true;
    services.thermald.enable = true;
    services.fwupd.enable = true;

    powerManagement.cpuFreqGovernor = "schedutil";

    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "lock";
    };

    environment.systemPackages = with pkgs; [
      powertop
    ];
  };
}
