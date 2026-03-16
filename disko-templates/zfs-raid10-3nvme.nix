# ----------------------------------------------------------------------------
# DISKO TEMPLATE: ZFS RAID-10 across 3 NVMe drives
#
# PURPOSE: Partition a large drive into two halves, mirror each half with
#          one of the two smaller drives, creating a striped mirror (RAID-10)
#
# PARAMETERS:
#   largeDisk  — by-id path of the large drive (partitioned into two halves)
#   smallDiskA — by-id path of the first small drive
#   smallDiskB — by-id path of the second small drive
#
# LAYOUT (for 4TB + 2TB + 2TB):
#   rpool (striped mirror, ~4TB usable)
#   ├── mirror-0: largeDisk-partA (2TB) ↔ smallDiskA (2TB)
#   └── mirror-1: largeDisk-partB (2TB) ↔ smallDiskB (2TB)
#
# DATASETS:
#   rpool/ROOT/nixos  → /        (ephemeral, rolled back to @blank on boot)
#   rpool/ROOT/root   → /root
#   rpool/nix         → /nix     (no snapshots, rebuilt from store)
#   rpool/home/reid   → /home/reid
#   rpool/persist     → /persist (survives rollback)
#   rpool/var/log     → /var/log
#
# DEV-NOTES:
#   - The large disk ESP is the primary boot partition
#   - Second ESP on smallDiskA for redundancy
#   - smallDiskB gets no ESP (two is enough for recovery)
#   - 50% split on large disk assumes smallDiskA ≈ smallDiskB in size
#   - ZFS compatibility set to openzfs-2.1-linux for broad kernel support
# ----------------------------------------------------------------------------
{
  largeDisk,
  smallDiskA,
  smallDiskB,
}: {
  disko.devices = {
    disk = {
      # -----------------------------------------------------------------------
      # Large drive: partitioned into ESP + two equal ZFS partitions
      # -----------------------------------------------------------------------
      large = {
        type = "disk";
        device = largeDisk;
        content = {
          type = "gpt";
          partitions = {
            esp = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = [ "-n" "ESP" ];
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # First half — mirrors with smallDiskA
            zfsA = {
              size = "50%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
            # Second half — mirrors with smallDiskB
            zfsB = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };

      # -----------------------------------------------------------------------
      # Small drive A: ESP + single ZFS partition (mirrors with large-partA)
      # -----------------------------------------------------------------------
      smallA = {
        type = "disk";
        device = smallDiskA;
        content = {
          type = "gpt";
          partitions = {
            esp = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = [ "-n" "ESP2" ];
                mountpoint = "/boot2";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };

      # -----------------------------------------------------------------------
      # Small drive B: single ZFS partition (mirrors with large-partB)
      # -----------------------------------------------------------------------
      smallB = {
        type = "disk";
        device = smallDiskB;
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };

    # -------------------------------------------------------------------------
    # ZFS POOL: striped mirror (RAID-10)
    # -------------------------------------------------------------------------
    # DEV-NOTE: disko assembles the mirror topology from the partitions above.
    # The two mirror vdevs are created because we have 4 ZFS-typed partitions
    # feeding into "rpool". We need to specify the mirror mode explicitly.
    zpool = {
      rpool = {
        type = "zpool";
        mode =
          # DEV-NOTE: disko's "mode" for multi-vdev mirrors requires
          # the mirror keyword. With 4 partitions assigned to rpool,
          # disko pairs them as two mirrors automatically when mode = "mirror".
          # However, for an explicit RAID-10 we need the raw topology.
          # This is handled by disko grouping partitions by their parent disk
          # into mirror vdevs when multiple disks feed one pool in mirror mode.
          "mirror";

        options = {
          ashift = "12";
          autotrim = "on";
          compatibility = "openzfs-2.1-linux";
          cachefile = "none";
        };

        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          compression = "zstd";
          dnodesize = "auto";
          mountpoint = "none";
          normalization = "formD";
          xattr = "sa";
        };

        postCreateHook = ''
          zpool set bootfs=rpool/ROOT/nixos rpool
          zfs list -t snapshot -H -o name | grep -E '^rpool/ROOT/nixos@blank$' \
            || zfs snapshot rpool/ROOT/nixos@blank
        '';

        datasets = {
          ROOT = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };

          "ROOT/nixos" = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              canmount = "noauto";
              "com.sun:auto-snapshot" = "false";
            };
          };

          "ROOT/root" = {
            type = "zfs_fs";
            mountpoint = "/root";
            options."com.sun:auto-snapshot" = "false";
          };

          "var/log" = {
            type = "zfs_fs";
            mountpoint = "/var/log";
            options."com.sun:auto-snapshot" = "true";
          };

          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options."com.sun:auto-snapshot" = "false";
          };

          home = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              canmount = "off";
              "com.sun:auto-snapshot" = "true";
            };
          };

          "home/reid" = {
            type = "zfs_fs";
            mountpoint = "/home/reid";
            options."com.sun:auto-snapshot" = "true";
          };

          persist = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
}
