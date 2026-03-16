# Adding a New Machine

## Checklist

- [ ] Create `machines/<hostname>/` directory
- [ ] Create `configuration.nix` — imports hardware, disko, impermanence, modules
- [ ] Create `hardware.nix` — run `nixos-generate-config --show-hardware-config` on target
- [ ] Create `disko.nix` — pick/create a template from `disko-templates/`
- [ ] Create `impermanence.nix` — start with the sixseven template, adjust paths
- [ ] Add machine to `clan.nix` → `inventory.machines` with tags and description
- [ ] Generate secrets: `clan vars generate --machine <hostname>`
- [ ] Set `networking.hostId` (first 8 chars of `/etc/machine-id` or `head -c 8 /etc/machine-id`)
- [ ] Set `system.stateVersion` to current NixOS version at install time
- [ ] Test: `nix flake check` or `clan vms run <hostname>`
- [ ] Deploy: `clan machines deploy <hostname>`

## Template: configuration.nix

```nix
{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./hardware.nix
    ./disko.nix
    ./impermanence.nix
    ../../modules/common.nix
    # Add feature modules as needed:
    # ../../modules/nvidia-laptop.nix
    # ../../modules/desktop-wayland.nix
    # ../../modules/user-reid.nix
  ];

  networking.hostName = "<hostname>";
  networking.hostId = "<8-char-hex>";

  # Enable feature modules:
  # my.nvidia-laptop.enable = true;
  # my.desktop-wayland.enable = true;
  # my.user-reid.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "25.11";
}
```

## Impermanence Gotchas

When adding services to a new machine, always check if they write state. Common persist paths:

| Service | Persist Path |
|---------|-------------|
| NetworkManager | `/etc/NetworkManager/system-connections`, `/var/lib/NetworkManager` |
| Tailscale | `/var/lib/tailscale` |
| Docker | `/var/lib/docker` |
| Postgres | `/var/lib/postgresql` |
| SSH host keys | `/etc/ssh/ssh_host_*` |
| Systemd timers | `/var/lib/systemd/timers` |
| ACME certs | `/var/lib/acme` |
| Prometheus | `/var/lib/prometheus2` |
| Grafana | `/var/lib/grafana` |
| Borgbackup | `/var/lib/borgbackup` |
