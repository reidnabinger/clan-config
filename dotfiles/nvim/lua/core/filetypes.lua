-- Language-specific configurations
-- Enhanced settings for bash, C, and Python

local M = {}

-- ============================================================================
-- Bash/Shell Script Configuration
-- ============================================================================

function M.setup_bash()
  local group = vim.api.nvim_create_augroup('BashSettings', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = { 'sh', 'bash', 'zsh' },
    callback = function(args)
      local bufnr = args.buf

      -- Formatting and indentation (following Google Shell Style Guide)
      vim.bo[bufnr].tabstop = 2
      vim.bo[bufnr].shiftwidth = 2
      vim.bo[bufnr].expandtab = true
      vim.bo[bufnr].textwidth = 80

      -- Comments
      vim.bo[bufnr].commentstring = '# %s'

      -- Shellcheck integration (if available)
      if vim.fn.executable('shellcheck') == 1 then
        vim.bo[bufnr].makeprg = 'shellcheck -f gcc %'
        vim.bo[bufnr].errorformat = '%f:%l:%c: %t%*[^:]: %m'

        -- Run shellcheck on save (optional, can be enabled)
        -- vim.api.nvim_create_autocmd('BufWritePost', {
        --   buffer = bufnr,
        --   callback = function()
        --     vim.cmd('silent make! | redraw! | cwindow')
        --   end,
        -- })
      end

      -- Keymaps for shell scripts
      local opts = { buffer = bufnr, silent = true }

      -- Insert shebang
      vim.keymap.set('n', '<leader>sb', function()
        local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
        if line ~= '#!/usr/bin/env bash' then
          vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { '#!/usr/bin/env bash', '' })
        end
      end, vim.tbl_extend('force', opts, { desc = 'Insert bash shebang' }))

      -- Make executable
      vim.keymap.set('n', '<leader>sx', function()
        local file = vim.fn.expand('%:p')
        vim.fn.system({ 'chmod', '+x', file })
        vim.notify('Made executable: ' .. vim.fn.expand('%:t'), vim.log.levels.INFO)
      end, vim.tbl_extend('force', opts, { desc = 'Make file executable' }))

      -- Run current script
      vim.keymap.set('n', '<leader>sr', function()
        vim.cmd('write')
        vim.cmd('!bash %')
      end, vim.tbl_extend('force', opts, { desc = 'Run bash script' }))

      -- Check syntax with bash -n
      vim.keymap.set('n', '<leader>sc', function()
        vim.cmd('write')
        local result = vim.fn.system('bash -n ' .. vim.fn.expand('%'))
        if vim.v.shell_error == 0 then
          vim.notify('Syntax OK', vim.log.levels.INFO)
        else
          vim.notify(result, vim.log.levels.ERROR)
        end
      end, vim.tbl_extend('force', opts, { desc = 'Check bash syntax' }))
    end,
  })
end

-- ============================================================================
-- C/C++ Configuration
-- ============================================================================

function M.setup_c()
  local group = vim.api.nvim_create_augroup('CSettings', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = { 'c', 'cpp', 'h', 'hpp' },
    callback = function(args)
      local bufnr = args.buf

      -- Formatting (K&R style with 4-space indent)
      vim.bo[bufnr].tabstop = 4
      vim.bo[bufnr].shiftwidth = 4
      vim.bo[bufnr].expandtab = true
      vim.bo[bufnr].textwidth = 80
      vim.bo[bufnr].cinoptions = ':0,l1,t0,g0,(0'  -- K&R indentation style

      -- Comments
      vim.bo[bufnr].commentstring = '// %s'

      -- Better include search
      vim.bo[bufnr].path = vim.bo[bufnr].path .. ',/usr/include,/usr/local/include'

      -- Keymaps for C/C++
      local opts = { buffer = bufnr, silent = true }

      -- Compile current file
      vim.keymap.set('n', '<leader>cc', function()
        vim.cmd('write')
        local ft = vim.bo.filetype
        local compiler = ft == 'cpp' and 'g++' or 'gcc'
        local input = vim.fn.expand('%')
        local output = vim.fn.expand('%:r')
        local cmd = string.format('%s -Wall -Wextra -g -o %s %s', compiler, output, input)
        vim.cmd('!' .. cmd)
      end, vim.tbl_extend('force', opts, { desc = 'Compile C/C++ file' }))

      -- Run compiled executable
      vim.keymap.set('n', '<leader>cr', function()
        local exe = vim.fn.expand('%:r')
        if vim.fn.filereadable(exe) == 1 then
          vim.cmd('!' .. exe)
        else
          vim.notify('Executable not found. Compile first.', vim.log.levels.WARN)
        end
      end, vim.tbl_extend('force', opts, { desc = 'Run C/C++ executable' }))

      -- Debug with gdb (if available)
      if vim.fn.executable('gdb') == 1 then
        vim.keymap.set('n', '<leader>cd', function()
          local exe = vim.fn.expand('%:r')
          if vim.fn.filereadable(exe) == 1 then
            vim.cmd('!gdb ' .. exe)
          else
            vim.notify('Executable not found. Compile first.', vim.log.levels.WARN)
          end
        end, vim.tbl_extend('force', opts, { desc = 'Debug with GDB' }))
      end

      -- Insert header guard (for .h files)
      if vim.bo.filetype == 'c' and vim.fn.expand('%:e') == 'h' then
        vim.keymap.set('n', '<leader>cg', function()
          local guard = string.upper(vim.fn.expand('%:t:r')) .. '_H'
          local lines = {
            '#ifndef ' .. guard,
            '#define ' .. guard,
            '',
            '',
            '',
            '#endif /* ' .. guard .. ' */',
          }
          vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, lines)
          vim.api.nvim_win_set_cursor(0, { 4, 0 })  -- Position cursor
        end, vim.tbl_extend('force', opts, { desc = 'Insert header guard' }))
      end
    end,
  })
end

-- ============================================================================
-- Python Configuration
-- ============================================================================

function M.setup_python()
  local group = vim.api.nvim_create_augroup('PythonSettings', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'python',
    callback = function(args)
      local bufnr = args.buf

      -- PEP 8 style
      vim.bo[bufnr].tabstop = 4
      vim.bo[bufnr].shiftwidth = 4
      vim.bo[bufnr].expandtab = true
      vim.bo[bufnr].textwidth = 88  -- Black default
      vim.wo.colorcolumn = '88,120'

      -- Python-specific options
      vim.bo[bufnr].fileformat = 'unix'

      -- Keymaps for Python
      local opts = { buffer = bufnr, silent = true }

      -- Run current file
      vim.keymap.set('n', '<leader>pr', function()
        vim.cmd('write')
        vim.cmd('!python3 %')
      end, vim.tbl_extend('force', opts, { desc = 'Run Python file' }))

      -- Run in interactive mode
      vim.keymap.set('n', '<leader>pi', function()
        vim.cmd('write')
        vim.cmd('!python3 -i %')
      end, vim.tbl_extend('force', opts, { desc = 'Run Python interactively' }))

      -- Check syntax with pylint (if available)
      if vim.fn.executable('pylint') == 1 then
        vim.keymap.set('n', '<leader>pl', function()
          vim.cmd('write')
          vim.cmd('!pylint %')
        end, vim.tbl_extend('force', opts, { desc = 'Run pylint' }))
      end

      -- Format with black (if available)
      if vim.fn.executable('black') == 1 then
        vim.keymap.set('n', '<leader>pf', function()
          vim.cmd('write')
          local file = vim.fn.expand('%')
          vim.fn.system({ 'black', file })
          vim.cmd('edit!')  -- Reload file
          vim.notify('Formatted with black', vim.log.levels.INFO)
        end, vim.tbl_extend('force', opts, { desc = 'Format with black' }))
      end

      -- Insert shebang
      vim.keymap.set('n', '<leader>pb', function()
        local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
        if line ~= '#!/usr/bin/env python3' then
          vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { '#!/usr/bin/env python3', '' })
        end
      end, vim.tbl_extend('force', opts, { desc = 'Insert Python shebang' }))

      -- Insert main guard
      vim.keymap.set('n', '<leader>pm', function()
        local lines = {
          '',
          '',
          'if __name__ == "__main__":',
          '    pass',
        }
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, lines)
      end, vim.tbl_extend('force', opts, { desc = 'Insert __main__ guard' }))
    end,
  })
end

-- ============================================================================
-- Nix Configuration
-- ============================================================================

function M.setup_nix()
  local group = vim.api.nvim_create_augroup('NixSettings', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'nix',
    callback = function(args)
      local bufnr = args.buf

      -- Formatting (2-space indent, standard for Nix)
      vim.bo[bufnr].tabstop = 2
      vim.bo[bufnr].shiftwidth = 2
      vim.bo[bufnr].expandtab = true
      vim.bo[bufnr].textwidth = 100

      -- Comments
      vim.bo[bufnr].commentstring = '# %s'

      -- Keymaps for Nix
      local opts = { buffer = bufnr, silent = true }

      -- Build current flake
      vim.keymap.set('n', '<leader>nb', function()
        vim.cmd('write')
        -- Check if we're in a flake directory
        if vim.fn.filereadable('flake.nix') == 1 then
          vim.cmd('!nix build')
        else
          vim.notify('No flake.nix found in current directory', vim.log.levels.WARN)
        end
      end, vim.tbl_extend('force', opts, { desc = 'Build Nix flake' }))

      -- Check flake
      vim.keymap.set('n', '<leader>nc', function()
        if vim.fn.filereadable('flake.nix') == 1 then
          vim.cmd('!nix flake check')
        else
          vim.notify('No flake.nix found in current directory', vim.log.levels.WARN)
        end
      end, vim.tbl_extend('force', opts, { desc = 'Check Nix flake' }))

      -- Update flake inputs
      vim.keymap.set('n', '<leader>nu', function()
        if vim.fn.filereadable('flake.nix') == 1 then
          vim.cmd('!nix flake update')
        else
          vim.notify('No flake.nix found in current directory', vim.log.levels.WARN)
        end
      end, vim.tbl_extend('force', opts, { desc = 'Update flake inputs' }))

      -- Develop shell (nix develop)
      vim.keymap.set('n', '<leader>nd', function()
        if vim.fn.filereadable('flake.nix') == 1 then
          vim.cmd('!nix develop')
        else
          vim.notify('No flake.nix found in current directory', vim.log.levels.WARN)
        end
      end, vim.tbl_extend('force', opts, { desc = 'Enter nix develop shell' }))

      -- Evaluate expression under cursor
      vim.keymap.set('n', '<leader>ne', function()
        vim.cmd('write')
        vim.cmd('!nix eval -f ' .. vim.fn.expand('%'))
      end, vim.tbl_extend('force', opts, { desc = 'Evaluate Nix file' }))

      -- Format with nixpkgs-fmt
      if vim.fn.executable('nixpkgs-fmt') == 1 then
        vim.keymap.set('n', '<leader>nf', function()
          vim.cmd('write')
          local file = vim.fn.expand('%')
          local result = vim.fn.system({ 'nixpkgs-fmt', file })
          if vim.v.shell_error == 0 then
            vim.cmd('edit!')
            vim.notify('Formatted with nixpkgs-fmt', vim.log.levels.INFO)
          else
            vim.notify(result, vim.log.levels.ERROR)
          end
        end, vim.tbl_extend('force', opts, { desc = 'Format with nixpkgs-fmt' }))
      elseif vim.fn.executable('alejandra') == 1 then
        -- Fallback to alejandra if available
        vim.keymap.set('n', '<leader>nf', function()
          vim.cmd('write')
          local file = vim.fn.expand('%')
          local result = vim.fn.system({ 'alejandra', file })
          if vim.v.shell_error == 0 then
            vim.cmd('edit!')
            vim.notify('Formatted with alejandra', vim.log.levels.INFO)
          else
            vim.notify(result, vim.log.levels.ERROR)
          end
        end, vim.tbl_extend('force', opts, { desc = 'Format with alejandra' }))
      end

      -- Repl: Open nix repl for current file
      vim.keymap.set('n', '<leader>nr', function()
        local file = vim.fn.expand('%:p')
        vim.cmd('!nix repl ' .. file)
      end, vim.tbl_extend('force', opts, { desc = 'Open Nix REPL' }))

      -- Show package info (for files in nixpkgs)
      vim.keymap.set('n', '<leader>ni', function()
        -- Get the attribute path under cursor
        local word = vim.fn.expand('<cword>')
        vim.cmd('!nix-env -qa --description ' .. word)
      end, vim.tbl_extend('force', opts, { desc = 'Show package info' }))
    end,
  })
end

-- ============================================================================
-- Setup all language configurations
-- ============================================================================

function M.setup()
  M.setup_bash()
  M.setup_c()
  M.setup_python()
  M.setup_nix()
end

return M
