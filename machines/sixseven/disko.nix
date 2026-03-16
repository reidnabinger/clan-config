# ----------------------------------------------------------------------------
# DISKO CONFIG: sixseven disk layout
#
# PURPOSE: Apply the mirror+rpool template with sixseven's actual disk IDs
#
# DEV-NOTES:
#   - Samsung 4TB (internal): ESP + hpool mirror leg + rpool (non-redundant)
#   - MKNSSD 2TB (internal): ESP + hpool mirror leg
#   - hpool (~1.8TB mirrored): home, persist, var/log — irreplaceable data
#   - rpool (~1.8TB single): root, nix — rebuildable from config
#   - WD BLACK 2TB was external and not available after kexec
# ----------------------------------------------------------------------------
import ../../disko-templates/zfs-mirror-2nvme.nix {
  largeDisk = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_4TB_S7KGNJ0WC16292D";
  smallDisk = "/dev/disk/by-id/nvme-MKNSSDPE2TB-D8_MK19082710056E56A";
}
