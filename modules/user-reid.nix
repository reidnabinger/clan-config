# ----------------------------------------------------------------------------
# MODULE: User account — reid
#
# PURPOSE: Create the reid user with standard groups and shell
#
# DEV-NOTES:
#   - No Home Manager — dotfiles managed manually or via stow
#   - SSH keys are set fleet-wide via clan sshd service
#   - initialPassword for first login; change immediately
# ----------------------------------------------------------------------------
{ config, lib, pkgs, ... }:
let
  cfg = config.my.user-reid;
in
{
  options.my.user-reid.enable = lib.mkEnableOption "User account: reid";

  config = lib.mkIf cfg.enable {
    users.users.reid = {
      isNormalUser = true;
      description = "Reid";
      initialPassword = "changeme";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "libvirtd"
        "video"
        "audio"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjT4ine3LG46PULl+VaCIPQUwryT8veSePfyOoAqQ9g protect-daemon@koshee.ai"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKIPNTdHSTDpDGI6jWoU6I7k1Tp3vyNHJRJZfBAmgo8Ug14XYbaR4MM4StTnIW5tseOjYShH46NXe23WhM26xIIXeimqWAQe3EikMTDZyiKMKGTqoyGfCA7RCSTu6Ete7ciQLbu7XEngZtYjs3YyxxK9t7QYhC9psfdDWXgrkP3ay4dQz1ITuPLiHT7IxyGUsdEGz5cyMY4P8iiG0yk4nHR9M5SfE5ywU51HvCLA8+DpeT31LB6W3laBJJn8z08xO3i60gKXlX4XLRukasESu7EvAAupzAfCpEwiHKSP14UOxMKzwGTqiuPeL4lLUDFPV9/7L7XyOnNJ9TtH6Sd5sfYYG2hFRXCav1jk1VAqawl83sc0ddAPMBmTEMMPllk0ls6ekF6chNxdeuMUhcTRmzY7tKsYRM3BNsFCJ6ZT1HY5xBQC6J1xn+gNv89G5LgSQqsrt/3Fw+m1PKqcu9gzre72RFxrARNshI12Jjc+NDhJT3tbUhesUf8D1oDrqdTbDZ932RpLL+1SVUVcs6JhwNjC6gfECfCiW1jGYBSgMdBKz59c8K9xJM5/zBEhaAhvSA7ZuCs5lS8HNQMmYr/QyhC2r8hdVzmWHDqA2QwGWNgnG4hiUvZVg+o6m3I6LVQ8IeX6RlV/2/KLEm8OCCV7SbixfGZSjG09TtFRl6yfDoPQ== reidn@m1.mbp"
      ];
    };
  };
}
