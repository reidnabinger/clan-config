# ----------------------------------------------------------------------------
# HARDWARE: sixseven — System76 Bonobo WS (bonw15)
#
# PURPOSE: Hardware-specific kernel modules, firmware, platform settings
#
# DEV-NOTES:
#   - i9-14900HX (Raptor Lake) + RTX 4090 Laptop (AD103M)
#   - Intel integrated graphics available but NVIDIA is primary
#   - System76 firmware daemon for BIOS/EC updates
# ----------------------------------------------------------------------------
{ lib, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  boot.kernelModules = [ "kvm-intel" ];

  services.xserver.xkb = {
    layout = lib.mkDefault "us";
    variant = lib.mkDefault "";
  };

  console.keyMap = lib.mkDefault "us";
}
