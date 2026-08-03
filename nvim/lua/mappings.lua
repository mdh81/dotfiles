require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Splits
map("n", "<C-w>v", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<C-w>n", "<cmd>split<CR>", { desc = "Horizontal split" })

-- Enter terminal normal mode with escape
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Enter normal mode in terminal" })


-- Buffer explorer
map("n", "\\be", "<cmd>BufExplorer<CR>", { desc = "Buffer Explorer" })

-- Telescope
map("n", "\\f", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "\\g", "<cmd>Telescope live_grep<CR>", { desc = "Find in files" })

-- Debugger

map("n", "<F9>", function()

  require("dap").continue()

end, { desc = "Debug start/continue" })

map("n", "<F5>", function()

  require("dap").toggle_breakpoint()

end, { desc = "Toggle breakpoint" })

map("n", "<F8>", function()

  require("dap").step_over()

end, { desc = "Step over" })

map("n", "<F7>", function()

  require("dap").step_into()

end, { desc = "Step into" })

map("n", "<S-F7>", function()

  require("dap").step_out()

end, { desc = "Step out" })

map("n", "<leader>du", function()

  require("dapui").toggle()

end, { desc = "Toggle debugger UI" })

map("n", "<leader>dr", function()

  require("dap").repl.toggle()

end, { desc = "Debugger REPL" })

map("n", "gl", function()
    vim.diagnostic.open_float({ scope = "cursor" })
  end, { desc = "Show diagnostic" })

map({ "n", "v" }, "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "LSP code action" })

