{ inputs, config, ... }: {
  perSystem =
    { pkgs, lib, ... }:
    let
      plugins = {
        "LazyVim" = pkgs.vimPlugins.LazyVim;
        "lazy.nvim" = pkgs.vimPlugins.lazy-nvim;
        "blink.cmp" = pkgs.vimPlugins.blink-cmp;
        "bufferline.nvim" = pkgs.vimPlugins.bufferline-nvim;
        "catppuccin" = pkgs.vimPlugins.catppuccin-nvim;
        "conform.nvim" = pkgs.vimPlugins.conform-nvim;
        "everforest" = pkgs.vimPlugins.everforest;
        "flash.nvim" = pkgs.vimPlugins.flash-nvim;
        "friendly-snippets" = pkgs.vimPlugins.friendly-snippets;
        "gitsigns.nvim" = pkgs.vimPlugins.gitsigns-nvim;
        "grug-far.nvim" = pkgs.vimPlugins.grug-far-nvim;
        "lazydev.nvim" = pkgs.vimPlugins.lazydev-nvim;
        "lualine.nvim" = pkgs.vimPlugins.lualine-nvim;
        "mini.ai" = pkgs.vimPlugins.mini-ai;
        "mini.icons" = pkgs.vimPlugins.mini-icons;
        "mini.pairs" = pkgs.vimPlugins.mini-pairs;
        "neo-tree.nvim" = pkgs.vimPlugins.neo-tree-nvim;
        "noice.nvim" = pkgs.vimPlugins.noice-nvim;
        "nui.nvim" = pkgs.vimPlugins.nui-nvim;
        "nvim-lint" = pkgs.vimPlugins.nvim-lint;
        "nvim-lspconfig" = pkgs.vimPlugins.nvim-lspconfig;
        "nvim-treesitter-textobjects" = pkgs.vimPlugins.nvim-treesitter-textobjects;
        "nvim-ts-autotag" = pkgs.vimPlugins.nvim-ts-autotag;
        "persistence.nvim" = pkgs.vimPlugins.persistence-nvim;
        "plenary.nvim" = pkgs.vimPlugins.plenary-nvim;
        "snacks.nvim" = pkgs.vimPlugins.snacks-nvim;
        "todo-comments.nvim" = pkgs.vimPlugins.todo-comments-nvim;
        "tokyonight.nvim" = pkgs.vimPlugins.tokyonight-nvim;
        "trouble.nvim" = pkgs.vimPlugins.trouble-nvim;
        "ts-comments.nvim" = pkgs.vimPlugins.ts-comments-nvim;
        "which-key.nvim" = pkgs.vimPlugins.which-key-nvim;
        "nvim-web-devicons" = pkgs.vimPlugins.nvim-web-devicons;
        "nvim-treesitter" = pkgs.vimPlugins.nvim-treesitter.withPlugins (
          p: with p; [
            nix
            lua
            bash
            json
            python
            rust
            javascript
            typescript
            tsx
            html
            css
            markdown
            markdown_inline
            vim
            vimdoc
            regex
            c
          ]
        );
      };
      pluginDir = pkgs.linkFarm "tongy-nvim-plugins" (
        lib.mapAttrsToList (name: path: { inherit name path; }) plugins
      );
    in
    {
      packages.neovim = inputs.wrappers.wrappers.neovim.wrap {
        inherit pkgs;
        settings.config_directory = ../assets/nvim;
        env.NIX_NVIM_PARSERS = "${pkgs.symlinkJoin {
          name = "tongy-treesitter-parsers";
          paths = plugins."nvim-treesitter".dependencies;
        }}";
        env.NIX_NVIM_PLUGINS = "${pluginDir}";
        runtimePkgs = with pkgs; [
          nixd
          lua-language-server
          pyright
          stylua
          ripgrep
          fd
          tree-sitter
          gcc
        ];
        specs.grammars.data = plugins."nvim-treesitter".dependencies;
        specs.bootstrap = {
          data = pkgs.vimPlugins.lazy-nvim;
        };
      };
    };
  flake.modules.nixos.editor = { pkgs, ... }: {
    environment.systemPackages = [ config.flake.packages.${pkgs.stdenv.hostPlatform.system}.neovim ];
  };
}
