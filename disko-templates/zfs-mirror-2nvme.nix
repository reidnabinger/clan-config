# ----------------------------------------------------------------------------
# DISKO TEMPLATE: ZFS mirror + non-redundant pool across 2 NVMe drives
#
# PARAMETERS:
#   largeDisk — by-id path of the larger drive (e.g., Samsung 4TB)
#   smallDisk — by-id path of the smaller drive (e.g., MKNSSD 2TB)
#
# LAYOUT:
#   largeDisk: [ESP 2G] [hpool-part ~1.8TB] [rpool-part ~1.8TB]
#   smallDisk: [ESP 2G] [hpool-part ~1.8TB]
#
#   hpool (mirror, ~1.8TB usable) — home, persist, var/log
#   ├── hpool-part on largeDisk ↔ hpool-part on smallDisk
#
#   rpool (single vdev, ~1.8TB) — system root, nix store
#   ├── rpool-part on largeDisk (non-redundant, rebuildable)
#
# DEV-NOTES:
#   - rpool holds / and /nix — both are rebuildable from the config
#   - hpool holds /home, /persist, /var/log — the irreplaceable data
#   - The split size (1845G) assumes smallDisk ≈ 1.8TB; adjust if needed
#   - rpool gets the leftover space on largeDisk after hpool partition
# ----------------------------------------------------------------------------
{
  largeDisk,
  smallDisk,
}:
{
  disko.devices = {
    disk = {
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
                extraArgs = [
                  "-n"
                  "ESP"
                ];
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # Mirrored with smallDisk — sized to match
            hpool = {
              size = "1845G";
              content = {
                type = "zfs";
                pool = "hpool";
              };
            };
            # Non-redundant — remainder of large disk
            rpool = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };

      small = {
        type = "disk";
        device = smallDisk;
        content = {
          type = "gpt";
          partitions = {
            esp = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = [
                  "-n"
                  "ESP2"
                ];
                mountpoint = "/boot2";
                mountOptions = [ "umask=0077" ];
              };
            };
            hpool = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "hpool";
              };
            };
          };
        };
      };
    };

    zpool = {
      # -----------------------------------------------------------------------
      # rpool: non-redundant system pool (rebuildable from config)
      # -----------------------------------------------------------------------
      rpool = {
        type = "zpool";
        # DEV-NOTE: single vdev, no mode needed

        options = {
          ashift = "12";
          autotrim = "on";
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

          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options."com.sun:auto-snapshot" = "false";
          };
        };
      };

      # -----------------------------------------------------------------------
      # hpool: mirrored pool for irreplaceable data
      # -----------------------------------------------------------------------
      hpool = {
        type = "zpool";
        mode = "mirror";

        options = {
          ashift = "12";
          autotrim = "on";
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

        datasets = {
          "var/log" = {
            type = "zfs_fs";
            mountpoint = "/var/log";
            options."com.sun:auto-snapshot" = "true";
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
