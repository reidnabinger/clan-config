# ----------------------------------------------------------------------------
# MODULE: Dotfiles deployment
#
# PURPOSE: Symlink declarative dotfile configs from the Nix store into
#          users' home directories via systemd-tmpfiles.
#
# USAGE:
#   my.dotfiles.enable = true;
#   my.dotfiles.users.reid = [ "nvim" "zsh" "tmux" ];
#
#   Each name maps to dotfiles/<name>/ in this repo, which gets linked
#   to ~/.config/<name>/ for each listed user.
#
# DEV-NOTES:
#   - /home is on hpool (persistent), so symlinks survive reboot
#   - Symlinks point into /nix/store, so configs are read-only at runtime
#   - Mutable state (lazy-lock.json, mason installs, etc.) lives outside
#     the symlink in ~/.local/share/<tool>/ — tools handle this natively
#   - To add a new dotfile set: create dotfiles/<name>/, add to user list
#   - Override mapping with my.dotfiles.mapping if config dir != name
#     (e.g., mapping.starship = ".config/starship.toml" for a single file)
# ----------------------------------------------------------------------------
{
  config,
  lib,
  ...
}:
let
  cfg = config.my.dotfiles;

  # Default: dotfiles/<name> → ~/.config/<name>
  # Override with cfg.mapping.<name> for non-standard paths
  dotfilesDir = ../dotfiles;

  mkTmpfilesRules =
    user: configs:
    builtins.concatMap (
      name:
      let
        src = dotfilesDir + "/${name}";
        target = cfg.mapping.${name} or ".config/${name}";
        dest = "/home/${user}/${target}";
      in
      [
        # DEV-NOTE: L+ means create symlink, replacing whatever exists.
        # The trailing - means don't fail if the source doesn't exist yet.
        "L+ ${dest} - ${user} users - ${src}"
      ]
    ) configs;

in
{
  options.my.dotfiles = {
    enable = lib.mkEnableOption "Declarative dotfile deployment";

    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };
      example = {
        reid = [
          "nvim"
          "zsh"
        ];
      };
      description = "Map of username → list of dotfile config names to deploy";
    };

    mapping = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        starship = ".config/starship.toml";
      };
      description = "Override target path (relative to ~) for a dotfile name";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = lib.concatLists (lib.mapAttrsToList mkTmpfilesRules cfg.users);
  };
}
