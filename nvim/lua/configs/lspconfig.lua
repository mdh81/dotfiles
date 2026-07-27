require("nvchad.configs.lspconfig").defaults()

local clangd_cmd = { "clangd" }
if vim.env.EMSDK and vim.env.EMSDK ~= "" then
  table.insert(
    clangd_cmd,
    "--query-driver=" .. vim.fs.joinpath(vim.env.EMSDK, "upstream", "emscripten", "em++")
  )
end

vim.lsp.config("clangd", {
  cmd = clangd_cmd,
})

local servers = { "basedpyright", "clangd", "cssls", "html" }
vim.lsp.enable(servers)

-- Add server-specific overrides with vim.lsp.config(); nvim-lspconfig
-- provides the defaults for the servers enabled above.
