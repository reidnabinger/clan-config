# ----------------------------------------------------------------------------
# FLAKE ENTRY POINT: Clan Fleet Configuration
#
# PURPOSE: Root flake for all machines managed by this clan
#
# DEV-NOTES:
#   - Clan wraps NixOS with fleet-level services (sshd, networking, backups)
#   - Machine configs auto-included from machines/<name>/configuration.nix
#   - Disk templates in disko-templates/, applied per-machine via clan CLI
#   - No Home Manager — user config is plain NixOS modules
#   - Uses standard Nix (not Lix) per Clan convention
# ----------------------------------------------------------------------------
{
  inputs.clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
  inputs.nixpkgs.follows = "clan-core/nixpkgs";

  inputs.impermanence.url = "github:nix-community/impermanence";

  outputs =
    {
      self,
      clan-core,
      nixpkgs,
      ...
    }@inputs:
    # DEV-NOTE: impermanence must be passed through to machine configs
    # via specialArgs since Clan doesn't include it by default
    let
      clan = clan-core.lib.clan {
        inherit self;
        imports = [ ./clan.nix ];
        specialArgs = { inherit inputs; };

        # DEV-NOTE: allowUnfree needed for NVIDIA drivers, firmware, etc.
        pkgsForSystem =
          system:
          import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
      };
    in
    {
      inherit (clan.config) nixosConfigurations nixosModules clanInternals;
      clan = clan.config;

      devShells =
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
          ]
          (system: {
            default = nixpkgs.legacyPackages.${system}.mkShell {
              packages = with nixpkgs.legacyPackages.${system}; [
                clan-core.packages.${system}.clan-cli
                nixfmt-rfc-style
                statix
                deadnix
                jq
              ];
              shellHook = ''
                echo "Clan Fleet Config — Dev Shell"
                echo ""
                echo "  clan machines list         — list machines"
                echo "  clan machines deploy <m>   — deploy a machine"
                echo "  clan vms run <m>           — test in VM"
                echo "  clan secrets set <s>       — set a secret"
                echo ""
              '';
            };
          });
    };
}
