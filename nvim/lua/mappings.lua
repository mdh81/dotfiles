require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Splits
map("n", "<C-w>v", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<C-w>n", "<cmd>split<CR>", { desc = "Horizontal split" })

vim.keymap.set("n", "\\be", "<cmd>BufExplorer<CR>", {
  desc = "Buffer Explorer",
})

-- Debugger

vim.keymap.set("n", "<F5>", function()

  require("dap").continue()

end, { desc = "Debug start/continue" })

vim.keymap.set("n", "<F9>", function()

  require("dap").toggle_breakpoint()

end, { desc = "Toggle breakpoint" })

vim.keymap.set("n", "<F10>", function()

  require("dap").step_over()

end, { desc = "Step over" })

vim.keymap.set("n", "<F11>", function()

  require("dap").step_into()

end, { desc = "Step into" })

vim.keymap.set("n", "<S-F11>", function()

  require("dap").step_out()

end, { desc = "Step out" })

vim.keymap.set("n", "<leader>du", function()

  require("dapui").toggle()

end, { desc = "Toggle debugger UI" })

vim.keymap.set("n", "<leader>dr", function()

  require("dap").repl.toggle()

end, { desc = "Debugger REPL" })

