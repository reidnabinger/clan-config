local M = {}

M.settings = {
  ['nil'] = {
    formatting = {
      command = { 'nixpkgs-fmt' },
    },
    diagnostics = {
      ignored = {},
      excludedFiles = {},
    },
    nix = {
      maxMemoryMB = 2560,
      flake = {
        autoArchive = true,
        autoEvalInputs = false,
        nixpkgsInputName = "nixpkgs",
      },
    },
  },
}

return M
