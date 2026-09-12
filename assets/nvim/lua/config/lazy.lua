vim.opt.rtp:append(vim.env.NIX_NVIM_PARSERS)
vim.opt.rtp:prepend(vim.env.NIX_NVIM_PLUGINS .. "/lazy.nvim")
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.editor.neo-tree" },
    { import = "plugins" },
  },
  pkg = { enabled = false },
  rocks = { enabled = false },
  defaults = { lazy = false, version = false },
  dev = { path = function(plugin) return vim.env.NIX_NVIM_PLUGINS .. "/" .. plugin.name end, patterns = { "." }, fallback = false },
  install = { missing = false, colorscheme = { "everforest" } },
  checker = { enabled = false },
  change_detection = { notify = false },
  performance = { rtp = { reset = false } },
})
