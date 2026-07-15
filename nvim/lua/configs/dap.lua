local dap = require "dap"

local codelldb = vim.fn.stdpath "data" .. "/mason/bin/codelldb"

dap.adapters.codelldb = {

  type = "server",

  port = "${port}",

  executable = {

    command = codelldb,

    args = { "--port", "${port}" },

  },

}

dap.configurations.cpp = {

  {

    name = "Launch executable",

    type = "codelldb",

    request = "launch",

    program = function()

      return vim.fn.input(

        "Path to executable: ",

        vim.fn.getcwd() .. "/",

        "file"

      )

    end,

    cwd = "${workspaceFolder}",

    stopOnEntry = false,

  },

}

dap.configurations.c = dap.configurations.cpp

