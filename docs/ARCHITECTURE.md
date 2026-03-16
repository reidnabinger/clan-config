# Architecture — clan-config

## Dependency Graph

```
flake.nix
  ├── clan-core (wraps nixpkgs)
  ├── impermanence
  └── clan.nix (inventory)
        ├── Fleet services (sshd, future: zerotier, borgbackup)
        └── machines/<name>/configuration.nix
              ├── hardware.nix (generated, machine-specific)
              ├── disko.nix → disko-templates/<template>.nix
              ├── impermanence.nix (persist paths)
              └── modules/*.nix (opt-in features)
                    └── common.nix (always imported)
```

## Key Design Decisions

### Why Clan, not plain NixOS flake?
Clan provides fleet-level abstractions: inventory-based service deployment, secrets management, machine discovery, and VM testing. Worth the complexity even at 1 machine because migration cost increases with fleet size.

### Why impermanence?
Forces explicit declaration of all persistent state. Prevents config drift. Makes machines truly reproducible — if it's not in the config, it doesn't survive reboot.

### Why ZFS?
Snapshots (for rollback), compression, checksumming, flexible pool topology. The initrd rollback to `@blank` snapshot is the mechanism impermanence uses.

### Why opt-in modules with `my.*` namespace?
Avoids NixOS module conflicts. Makes it clear what's ours vs upstream. `lib.mkEnableOption` means a machine that doesn't set `my.foo.enable = true` is completely unaffected.

### Why no Home Manager?
Complexity cost not justified yet. User-level config is minimal. Reconsider if dotfile management becomes painful across multiple machines.

## Module Dependency Rules

- `common.nix` depends on nothing custom (only nixpkgs).
- Feature modules (`nvidia-laptop`, `laptop-power`, etc.) depend on nothing custom.
- Machine configs import `common.nix` + whichever feature modules apply.
- **No module should import another feature module.** Composition happens in machine config.
- `clan.nix` never imports machine configs directly (Clan handles this).

## Data Flow: Secrets

```
clan secrets set <name>
  → encrypted in repo (.git/clan.lock, sops)
  → decrypted at deploy time on target machine
  → available as files under /run/secrets/
```

## Data Flow: Deploy

```
clan machines deploy <name>
  → nix build (local or remote)
  → nix copy to target
  → nixos-rebuild switch on target
  → reboot → initrd rolls back / → mounts /persist → boot continues
```
