local Plug = vim.fn["plug#"]
vim.call("plug#begin", "~/.config/nvim/plugged")
-- DEFAULTS
Plug("tpope/vim-sensible")

-- EDITING QUALITY OF LIFE
Plug("tpope/vim-commentary")
Plug("christoomey/vim-tmux-navigator")
Plug("rmagatti/auto-session")
Plug("itchyny/vim-qfedit")
-- Plug 'jiangmiao/auto-pairs'
Plug("mg979/vim-visual-multi", { branch = "master" })
Plug("kylechui/nvim-surround")
Plug("nathanaelkane/vim-indent-guides")

-- GIT STUFF
Plug("APZelos/blamer.nvim")
Plug("nvim-lua/plenary.nvim")
Plug("airblade/vim-gitgutter")
Plug("linrongbin16/gitlinker.nvim")

-- LSP
Plug("nvimtools/none-ls.nvim")
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
Plug("WhoIsSethDaniel/mason-tool-installer.nvim")
Plug("neovim/nvim-lspconfig")
Plug("nvim-treesitter/nvim-treesitter")
Plug("stevearc/conform.nvim")
Plug("b0o/SchemaStore.nvim")
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("ThePrimeagen/refactoring.nvim", {
	dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
})

-- DEBUGGING
Plug("nvim-neotest/nvim-nio")
Plug("mfussenegger/nvim-dap")
Plug("rcarriga/nvim-dap-ui")
Plug("theHamsta/nvim-dap-virtual-text")
Plug("julianolf/nvim-dap-lldb")

-- UI TWEEKS
Plug("vim-airline/vim-airline")
-- Plug 'wellle/context.vim' -- questionable performance
Plug("sainnhe/gruvbox-material")
Plug("petertriho/nvim-scrollbar")
Plug("folke/zen-mode.nvim")

-- NAVIGATION
Plug("preservim/nerdtree")
Plug("unkiwii/vim-nerdtree-sync")
Plug("junegunn/fzf.vim")
Plug("junegunn/fzf")
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-telescope/telescope-fzf-native.nvim", { run = "make" })

-- NOTETAKING
Plug("epwalsh/obsidian.nvim", {
	dependencies = { "nvim-lua/plenary.nvim" },
})

-- DBUI
Plug("tpope/vim-dadbod")
Plug("kristijanhusak/vim-dadbod-ui")

-- AI
local is_cat = string.find(vim.fn.getcwd(), "cat")
local is_obsidian = string.find(vim.fn.getcwd(), "obsidian")

if is_obsidian then
	vim.g.codeium_enabled = false
	vim.g.copilot_enabled = false
else
	if is_cat then
		Plug("github/copilot.vim")
		vim.g.codeium_enabled = false
	else
		Plug("Exafunction/codeium.vim")
		vim.g.copilot_enabled = false
	end
	Plug("panozzaj/vim-copilot-ignore")
end

-- FUN
Plug("ThePrimeagen/vim-be-good")
Plug("vuciv/golf")

vim.call("plug#end")
