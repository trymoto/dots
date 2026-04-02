require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua",
		"vim",
		"help",
		"javascript",
		"typescript",
		"tsx",
		"rust",
		"toml",
		"go",
		"c",
		"markdown",
		"markdown_inline",
	},
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	ident = { enable = true },
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
	},
	refactor = {
		highlight_definitions = {
			enable = true,
		},
		highlight_current_scope = {
			enable = true,
		},
	},
})
