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

map("n", "<F5>", function()

  require("dap").continue()

end, { desc = "Debug start/continue" })

map("n", "<F9>", function()

  require("dap").toggle_breakpoint()

end, { desc = "Toggle breakpoint" })

map("n", "<F10>", function()

  require("dap").step_over()

end, { desc = "Step over" })

map("n", "<F11>", function()

  require("dap").step_into()

end, { desc = "Step into" })

map("n", "<S-F11>", function()

  require("dap").step_out()

end, { desc = "Step out" })

map("n", "<leader>du", function()

  require("dapui").toggle()

end, { desc = "Toggle debugger UI" })

map("n", "<leader>dr", function()

  require("dap").repl.toggle()

end, { desc = "Debugger REPL" })

-- Reloads a specific module (e.g., your options or plugin configs)
map("n", "\r", function()
    -- Replace 'user.options' with your actual module path relative to your lua/ folder
    require('plenary.reload').reload_module('user.options')
    require('user.options')
    print("Config reloaded!")
end, { desc = 'Reload Lua modules' })
