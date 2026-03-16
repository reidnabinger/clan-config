return {
  'williamboman/mason.nvim',
  optional = true,
  opts = function(_, opts)
    opts.ui = opts.ui or {}
    opts.ui.check_outdated_packages_on_open = true
    opts.ui.border = 'rounded'
    
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MasonUpdateAllComplete',
      callback = function()
        vim.notify('Mason: All packages updated!', vim.log.levels.INFO)
      end,
    })
    
    return opts
  end,
}
