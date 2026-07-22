require("nvchad.configs.lspconfig").defaults()

local servers = { "basedpyright", "clangd", "cssls", "html" }
vim.lsp.enable(servers)

-- Add server-specific overrides with vim.lsp.config(); nvim-lspconfig
-- provides the defaults for the servers enabled above.
