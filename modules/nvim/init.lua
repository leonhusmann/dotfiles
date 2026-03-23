vim.g.mapleader = " "

-- Auto-refresh
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function() if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end end,
})

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.shiftwidth = 2
opt.expandtab = true
opt.ignorecase = true
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.inccommand = "split"

-- Disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(e)
          local opts = { buffer = e.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
        end,
      })
      local caps = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.config('lua_ls', { capabilities = caps, settings = { Lua = { diagnostics = { globals = { 'vim' } } } } })
      vim.lsp.enable({ 'gopls', 'lua_ls', 'ts_ls' })
    end
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-buffer", "L3MON4D3/LuaSnip" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(a) require("luasnip").lsp_expand(a.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = { { name = "nvim_lsp" }, { name = "buffer" } }
      })
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "lua", "go", "typescript", "javascript", "bash", "nix", "markdown" },
        highlight = { enable = true },
      })
    end
  },

  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")
      vim.keymap.set("n", "<C-p>", fzf.files)
      vim.keymap.set("n", "<C-g>", fzf.live_grep)
      vim.keymap.set("n", "<leader>b", fzf.buffers)
    end
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        renderer = { highlight_git = true, icons = { show = { file = true, folder = true, git = true } } }
      })
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
    end
  },

  { "lewis6991/gitsigns.nvim", config = function() require("gitsigns").setup() end },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "catppuccin", globalstatus = true, component_separators = "", section_separators = "" },
        sections = { lualine_a = {'mode'}, lualine_b = {'branch'}, lualine_c = {'filename'}, lualine_x = {'diagnostics'}, lualine_y = {'progress'}, lualine_z = {'location'} }
      })
    end
  },

  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "mbbill/undotree" }
})

vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")
