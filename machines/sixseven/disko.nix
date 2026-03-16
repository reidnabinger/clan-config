# ----------------------------------------------------------------------------
# DISKO CONFIG: sixseven disk layout
#
# PURPOSE: Apply the RAID-10 template with sixseven's actual disk IDs
#
# DEV-NOTES:
#   - Samsung 990 PRO 4TB is split in half, each half mirrors a 2TB drive
#   - ~4TB usable in RAID-10 configuration
#   - Any single drive failure is survivable
# ----------------------------------------------------------------------------
import ../../disko-templates/zfs-raid10-3nvme.nix {
  largeDisk  = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_4TB_S7KGNJ0WC16292D";
  smallDiskA = "/dev/disk/by-id/nvme-MKNSSDPE2TB-D8_MK19082710056E56A";
  smallDiskB = "/dev/disk/by-id/nvme-WD_BLACK_SN770_2TB_23364Y803731";
}
