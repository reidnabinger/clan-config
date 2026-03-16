-- Mason.nvim - Package manager for LSP servers, DAP, linters, formatters

return {
  'williamboman/mason.nvim',
  -- CRITICAL: Must eager-load (lazy = false) - mason modifies PATH early
  lazy = false,
  priority = 1000,
  cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUpdate', 'MasonLog' },
  build = ':MasonUpdate',
  opts = {
    install_root_dir = vim.fn.stdpath('data') .. '/mason',
    PATH = 'prepend',
    max_concurrent_installers = 8,
    ui = {
      check_outdated_packages_on_open = true,
      border = 'rounded',
      width = 0.8,
      height = 0.85,
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
      keymaps = {
        toggle_package_expand = '<CR>',
        install_package = 'i',
        update_package = 'u',
        check_package_version = 'c',
        update_all_packages = 'U',
        check_outdated_packages = 'C',
        uninstall_package = 'X',
        cancel_installation = '<C-c>',
        apply_language_filter = '<C-f>',
        toggle_package_install_log = '<CR>',
        toggle_help = 'g?',
      },
    },
    log_level = vim.log.levels.INFO,
    registries = { 'github:mason-org/mason-registry' },
  },
}
