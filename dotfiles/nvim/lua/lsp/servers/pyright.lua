local M = {}

M.settings = {
  python = {
    analysis = {
      typeCheckingMode = 'basic',
      autoSearchPaths = true,
      useLibraryCodeForTypes = true,
      diagnosticSeverityOverrides = {
        reportUnusedVariable = 'warning',
        reportUnusedImport = 'warning',
        reportGeneralTypeIssues = 'warning',
      },
      inlayHints = {
        variableTypes = true,
        functionReturnTypes = true,
      },
    },
  },
}

return M
