-- Minimal init.lua for testing contrast.nvim
-- All paths are local to sandbox/ (nothing touches ~/.local/state)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- Settings
-- ============================================================================
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.showmode = false

-- ============================================================================
-- Bootstrap lazy.nvim
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Plugins
-- ============================================================================
require("lazy").setup({
  -- Theme
  {
    dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h"),
    name = "contrast",
    priority = 1000,
    opts = {
      transparent = false,
      cursorline = true,
    },
    config = function(_, opts)
      require("contrast").setup(opts)
      vim.cmd("colorscheme contrast")
    end,
  },

  -- Treesitter (main branch for Neovim 0.12+)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- Install parsers asynchronously
      local parsers = {
        "lua", "vim", "vimdoc",
        "json", "yaml", "toml",
        "c", "cpp", "rust", "zig",
        "java", "scala", "typescript", "javascript", "tsx", "jsx",
        "go", "bash", "markdown", "markdown_inline",
      }
      require("nvim-treesitter").install(parsers)

      -- Safely enable treesitter highlighting for supported filetypes
      local ts_filetypes = {
        "lua", "vim", "vimdoc",
        "json", "yaml", "toml",
        "c", "cpp", "rust", "zig",
        "java", "scala", "typescript", "typescriptreact",
        "javascript", "javascriptreact",
        "go", "bash", "markdown",
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = ts_filetypes,
        callback = function(args)
          -- Only start if parser is actually available
          local lang = vim.treesitter.language.get_lang(args.match)
          if lang and pcall(vim.treesitter.language.inspect, lang) then
            vim.treesitter.start(args.buf, lang)
          end
        end,
      })
    end,
  },

  -- Which-key
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- Gitsigns
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", opts = {} },

  -- Indent guides
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
}, {
  ui = { border = "rounded" },
})

-- ============================================================================
-- Keymaps
-- ============================================================================
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Theme switching (standard vim way)
vim.keymap.set("n", "<leader>td", "<cmd>set background=dark<cr>",  { desc = "Dark" })
vim.keymap.set("n", "<leader>tl", "<cmd>set background=light<cr>", { desc = "Light" })
vim.keymap.set("n", "<leader>tt", function()
  vim.o.background = vim.o.background == "dark" and "light" or "dark"
end, { desc = "Toggle theme" })

-- Accent color cycling (hue in degrees, 30-degree steps)
local preset_hues = {
  0,    -- red
  30,   -- orange
  50,   -- yellow
  120,  -- green
  160,  -- teal
  200,  -- cyan
  220,  -- blue (default)
  260,  -- indigo
  280,  -- purple
  320,  -- pink
}
local accent_idx = 7 -- start at blue (220)

vim.keymap.set("n", "<leader>ac", function()
  accent_idx = (accent_idx % #preset_hues) + 1
  require("contrast").set_accent(preset_hues[accent_idx])
  print("accent hue: " .. preset_hues[accent_idx])
end, { desc = "Next accent" })

vim.keymap.set("n", "<leader>aC", function()
  accent_idx = (accent_idx - 2) % #preset_hues + 1
  require("contrast").set_accent(preset_hues[accent_idx])
  print("accent hue: " .. preset_hues[accent_idx])
end, { desc = "Prev accent" })

vim.keymap.set("n", "<leader>a?", function()
  print("accent hue: " .. require("contrast").get_hue())
end, { desc = "Show accent hue" })

-- Manual treesitter enable (after parsers install)
vim.keymap.set("n", "<leader>ts", function()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local lang = vim.treesitter.language.get_lang(ft)
  if lang and pcall(vim.treesitter.language.inspect, lang) then
    vim.treesitter.start(buf, lang)
    print("Treesitter enabled: " .. lang)
  else
    print("Parser not available for: " .. ft)
  end
end, { desc = "Enable treesitter" })
