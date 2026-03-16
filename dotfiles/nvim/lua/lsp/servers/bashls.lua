local M = {}

M.settings = {
  bashIde = {
    globPattern = '*@(.sh|.inc|.bash|.command|.zsh)',
    shellcheckPath = vim.fn.executable('shellcheck') == 1 and 'shellcheck' or '',
  },
}

return M
