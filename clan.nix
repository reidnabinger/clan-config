# ----------------------------------------------------------------------------
# CLAN INVENTORY: Fleet-wide service and machine definitions
#
# PURPOSE: Central inventory defining machines, roles, and shared services
#
# DEV-NOTES:
#   - machines/<name>/configuration.nix is auto-imported per machine
#   - Tags group machines by role (e.g., "prod", "dev", "personal")
#   - Services are applied across machines via roles + tags
#   - Secrets managed via clan vars + sops
# ----------------------------------------------------------------------------
{
  meta.name = "clan-config";
  meta.domain = "clan";

  # ---------------------------------------------------------------------------
  # MACHINES
  # ---------------------------------------------------------------------------
  inventory.machines = {
    sixseven = {
      tags = [ "personal" "nixos" "laptop" ];
      description = "System76 Bonobo WS — i9-14900HX, RTX 4090 Laptop, 64GB";
      system = "x86_64-linux";
    };
  };

  # ---------------------------------------------------------------------------
  # FLEET SERVICES
  # ---------------------------------------------------------------------------
  inventory.instances = {

    sshd = {
      roles.server.tags.nixos = { };
      roles.server.settings.authorizedKeys = {
        "reid-rsa" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKIPNTdHSTDpDGI6jWoU6I7k1Tp3vyNHJRJZfBAmgo8Ug14XYbaR4MM4StTnIW5tseOjYShH46NXe23WhM26xIIXeimqWAQe3EikMTDZyiKMKGTqoyGfCA7RCSTu6Ete7ciQLbu7XEngZtYjs3YyxxK9t7QYhC9psfdDWXgrkP3ay4dQz1ITuPLiHT7IxyGUsdEGz5cyMY4P8iiG0yk4nHR9M5SfE5ywU51HvCLA8+DpeT31LB6W3laBJJn8z08xO3i60gKXlX4XLRukasESu7EvAAupzAfCpEwiHKSP14UOxMKzwGTqiuPeL4lLUDFPV9/7L7XyOnNJ9TtH6Sd5sfYYG2hFRXCav1jk1VAqawl83sc0ddAPMBmTEMMPllk0ls6ekF6chNxdeuMUhcTRmzY7tKsYRM3BNsFCJ6ZT1HY5xBQC6J1xn+gNv89G5LgSQqsrt/3Fw+m1PKqcu9gzre72RFxrARNshI12Jjc+NDhJT3tbUhesUf8D1oDrqdTbDZ932RpLL+1SVUVcs6JhwNjC6gfECfCiW1jGYBSgMdBKz59c8K9xJM5/zBEhaAhvSA7ZuCs5lS8HNQMmYr/QyhC2r8hdVzmWHDqA2QwGWNgnG4hiUvZVg+o6m3I6LVQ8IeX6RlV/2/KLEm8OCCV7SbixfGZSjG09TtFRl6yfDoPQ== reidn@m1.mbp";
        "reid-kosheeprotect" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY/2GC8cHrDygNL5jR9OGMS+hJ5rcjpXaI/HL88zEaD protect-admins@koshee.ai";
      };
    };

    user-root = {
      module.name = "users";
      roles.default.tags.nixos = { };
      roles.default.settings = {
        user = "root";
        prompt = true;
      };
    };

    # DEV-NOTE: zerotier/wireguard networking and borgbackup will be
    # added when the fleet grows beyond one machine.
  };

  machines = { };
}
