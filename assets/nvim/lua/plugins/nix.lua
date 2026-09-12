return {
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "nvim-treesitter/nvim-treesitter", build = false, opts = function(_, opts) opts.ensure_installed = {}; opts.auto_install = false end },
  { "neovim/nvim-lspconfig", opts = { servers = { nixd = {}, lua_ls = {}, pyright = {} } } },
}
