# Adding a New Module

## Rules

1. One concern per module. Don't bundle unrelated features.
2. Always use `my.<name>.enable = lib.mkEnableOption "<description>"`.
3. Never import other feature modules from within a module.
4. Add a header comment block with PURPOSE and DEV-NOTES.
5. Put it in `modules/<name>.nix`.

## Template

```nix
# ----------------------------------------------------------------------------
# MODULE: <descriptive name>
#
# PURPOSE: <what this does>
#
# DEV-NOTES:
#   - <anything non-obvious>
# ----------------------------------------------------------------------------
{ config, lib, pkgs, ... }:
let
  cfg = config.my.<name>;
in
{
  options.my.<name>.enable = lib.mkEnableOption "<description>";

  config = lib.mkIf cfg.enable {
    # Your config here
  };
}
```

## After Creating

1. Import in target machine's `configuration.nix`
2. Enable with `my.<name>.enable = true;`
3. If the module's service writes state, add persist paths to `impermanence.nix`
4. Test with `nix flake check`

## When to Create a Module vs Inline

- **Module**: Reusable across machines, or complex enough to deserve isolation
- **Inline in machine config**: One-off, machine-specific, simple (< 10 lines)
