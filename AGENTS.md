# CLAUDE.md — clan-config Agent Instructions

## What This Repo Is

NixOS fleet configuration managed by [Clan](https://clan.lol). One flake, one clan, N machines. Uses ZFS, impermanence, disko, and Clan's inventory system for fleet-wide services.

## Repo Structure

```
flake.nix                    # Entry point — clan-core wraps NixOS
clan.nix                     # Inventory: machines, tags, fleet services
machines/<name>/
  configuration.nix          # Machine entry point (imports modules)
  hardware.nix               # Hardware-specific (generated)
  disko.nix                  # Disk layout (calls a disko-template)
  impermanence.nix           # Persist paths for this machine
modules/
  common.nix                 # Universal base config (every machine imports this)
  nvidia-laptop.nix          # Feature module (opt-in via my.*.enable)
  laptop-power.nix           # Feature module
  desktop-wayland.nix        # Feature module
  user-reid.nix              # User account module
disko-templates/             # Reusable disko layouts parameterized by disk paths
```

## Hard Rules

1. **One feature, one branch.** Never commit directly to `main`.
2. **Every file gets a header comment block** with PURPOSE and DEV-NOTES sections. Follow the existing pattern.
3. **Add `# DEV-NOTE` comments** for tricky behavior, bugs, workarounds, or assumptions. Read existing DEV-NOTEs before editing any file.
4. **No Home Manager.** User dotfiles are out of scope. User accounts are NixOS modules.
5. **Impermanence is active.** Root (`/`) is wiped on every boot. If a service needs state, add its paths to the machine's `impermanence.nix`. Forgetting this **will lose data**.
6. **Modules are opt-in.** Every feature module uses `my.<name>.enable = lib.mkEnableOption`. Machines opt in explicitly.
7. **common.nix stays minimal.** Only truly universal settings. If it doesn't apply to every machine, it's a feature module.
8. **Secrets via Clan vars/sops.** Never commit secrets, keys, or passwords to the repo. Use `clan secrets`.
9. **Test before deploying.** Use `nix flake check` or `clan vms run <machine>` before pushing.
10. **No self-attribution** in commits or code.

## Naming Conventions

- **Machines**: lowercase, short hostnames (e.g., `sixseven`). Directory = hostname.
- **Modules**: `modules/<descriptive-name>.nix`. Option namespace: `my.<name>`.
- **Disko templates**: `disko-templates/<topology>.nix` (e.g., `zfs-mirror-2nvme.nix`).
- **Tags** in inventory: role-based (`personal`, `server`, `router`) and OS-based (`nixos`).

## Common Workflows

### Add a new machine
```bash
mkdir machines/<name>
# Create: configuration.nix, hardware.nix, disko.nix, impermanence.nix
# Add to clan.nix inventory.machines with tags + description
# Generate secrets: clan vars generate --machine <name>
```

### Add a new feature module
```bash
# Create modules/<name>.nix with mkEnableOption pattern
# Import in target machine's configuration.nix
# Enable with my.<name>.enable = true
```

### Add a persist path (impermanence)
Edit `machines/<name>/impermanence.nix` — add to `directories` or `files` under `environment.persistence."/persist"`.

### Deploy
```bash
clan machines deploy <name>    # remote deploy
sudo nixos-rebuild switch --flake .#<name>  # local
```

### Lint
```bash
nixfmt-rfc-style **/*.nix     # formatting
statix check .                 # anti-patterns
deadnix .                      # dead code
```

## Growth Projections & Preemptive Decisions

### Near-term (2-5 machines)
- **Networking**: Add ZeroTier or WireGuard via Clan inventory service when machine #2 arrives. Placeholder commented in `clan.nix`.
- **Backups**: BorgBackup via Clan service. One machine tagged `backup-server`, others as clients.
- **Secrets rotation**: Establish a schedule. Clan's cert/key generators handle the mechanics.

### Mid-term (5-15 machines)
- **Machine archetypes**: Factor out role-based module bundles (e.g., `roles/workstation.nix` = common + desktop + user modules). Avoids import list drift.
- **Per-machine overrides directory**: If machines diverge heavily, consider `machines/<name>/overrides/` to keep `configuration.nix` clean.
- **CI**: Add GitHub Actions or similar to run `nix flake check` on every PR. Non-negotiable once fleet > 3.
- **Disko template library**: More templates as hardware diversifies. Keep parameterized.

### Long-term (15+ machines / heterogeneous fleet)
- **Inventory tags become critical.** Design tag taxonomy early: `{role}/{environment}/{location}`.
- **Separate secrets store**: If Clan vars scaling becomes painful, evaluate sops-nix with age keys per-machine.
- **Monitoring/observability**: Prometheus + Grafana module, deployed via inventory roles.
- **Image-based deploys**: For ephemeral/cloud machines, generate images instead of `nixos-rebuild`.

## Known Tech Debt & Pain Points

| Issue | Status | Mitigation |
|-------|--------|------------|
| `user-root` prompt needs TTY | Commented out in `clan.nix` | Re-enable when deploying from terminal |
| SSH keys duplicated (user module + clan sshd) | Works but redundant | Consolidate to clan sshd only when possible |
| No CI | Acceptable at 1 machine | Add before machine #2 |
| `initialPassword = "changeme"` | Security risk | Change immediately after first login; consider removing |
| No backup service | No redundancy yet | Add borgbackup with machine #2 |

## Debugging

1. Read the DEV-NOTEs in the file you're editing.
2. Re-read this CLAUDE.md.
3. For impermanence issues: check if the path is in `impermanence.nix`. It almost certainly isn't.
4. For ZFS issues: `zpool status`, `zfs list -t snapshot`. The rollback service runs in initrd.
5. For Clan issues: `clan vars generate`, `clan secrets`, check `.git/clan.lock`.
6. For build failures: `nix flake check`, then `nix build .#nixosConfigurations.<machine>.config.system.build.toplevel` for full error output.
