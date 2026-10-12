return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { "markdown" }, -- Force lazy.nvim to wake it up for markdown files
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons', 
    },
    opts = {
      enabled = true,
      render_modes = { 'n', 'c', 't' }, 
    },
  },
}
