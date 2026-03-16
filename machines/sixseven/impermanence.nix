# ----------------------------------------------------------------------------
# IMPERMANENCE: sixseven — ephemeral root with ZFS rollback
#
# PURPOSE: Roll back / to a blank ZFS snapshot on every boot.
#          Persistent state lives on /persist.
#
# DEV-NOTES:
#   - Root is rolled back in initrd before anything mounts
#   - /persist must be listed in neededForBoot or services that depend
#     on persisted state will fail during activation
#   - Add new persist paths here as services are added
# ----------------------------------------------------------------------------
_: {
  fileSystems."/persist".neededForBoot = true;

  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [
      "mode=1777"
      "nosuid"
      "nodev"
    ];
  };

  # DEV-NOTE: Clan uses systemd stage 1, so we use a systemd service
  # in initrd instead of postDeviceCommands.
  boot.initrd.systemd.services.zfs-rollback-root = {
    description = "Rollback rpool/ROOT/nixos to blank snapshot";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-rpool.service" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig = {
      Type = "oneshot";
    };
    # DEV-NOTE: In initrd, zfs is available on PATH from boot.zfs support.
    # Using a script avoids needing to resolve store paths in initrd.
    script = ''
      if zfs list -H -o name rpool/ROOT/nixos@blank >/dev/null 2>&1; then
        echo "initrd: rolling back rpool/ROOT/nixos to @blank"
        zfs rollback -r rpool/ROOT/nixos@blank
      else
        echo "initrd: missing rpool/ROOT/nixos@blank; skipping rollback" >&2
      fi
    '';
  };

  # DEV-NOTE: Extend these lists as services are added.
  # Anything not listed here is wiped on reboot.
  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
      "/var/lib/nixos"
      "/var/lib/systemd/timers"
      "/var/lib/tailscale"
    ];

    files = [
      "/etc/machine-id"
      {
        file = "/etc/ssh/ssh_host_ed25519_key";
        parentDirectory.mode = "0700";
      }
      {
        file = "/etc/ssh/ssh_host_ed25519_key.pub";
        parentDirectory.mode = "0700";
      }
      {
        file = "/etc/ssh/ssh_host_rsa_key";
        parentDirectory.mode = "0700";
      }
      {
        file = "/etc/ssh/ssh_host_rsa_key.pub";
        parentDirectory.mode = "0700";
      }
    ];
  };
}
