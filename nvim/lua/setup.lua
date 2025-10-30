require("mason").setup()
require("mason-lspconfig").setup()

require("scrollbar").setup()
require("nvim-surround").setup()
require("gitlinker").setup()

require("zen-mode").setup({
	window = {
		width = 80,
		options = {
			signcolumn = "no", -- disable signcolumn
			number = false, -- disable number column
			relativenumber = false, -- disable relative numbers
			foldcolumn = "0", -- disable fold column
			list = false, -- disable whitespace characters
		},
	},
	on_open = function(win)
		vim.cmd("ScrollbarHide")
		vim.cmd("set linebreak")
	end,
	on_close = function()
		vim.cmd("ScrollbarShow")
		vim.cmd("set nolinebreak")
	end,
})

vim.g.nerdtree_sync_cursorline = 1
vim.g.blamer_enabled = true
vim.g.blamer_relative_time = 1
vim.g.blamer_show_in_visual_modes = 0
vim.g.blamer_show_in_insert_modes = 0
vim.g.airline_section_b = ""

vim.api.nvim_set_option("background", "dark")
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_better_performance = 1
vim.cmd("colorscheme gruvbox-material")

require("auto-session").setup({
	auto_session_enable_last_session = false,
	auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
	auto_session_enabled = true,
	auto_save_enabled = true,
	auto_restore_enabled = true,
	auto_session_suppress_dirs = nil,
})

vim.g.dbs = {
	pro_local = "postgresql://postgres:postgres@localhost:2000/postgres",
}

-- dap stuff

local dap = require("dap")
local ui = require("dapui")
local vt = require("nvim-dap-virtual-text")

HOME_PATH = os.getenv("HOME") .. "/"
MASON_PATH = HOME_PATH .. ".local/share/nvim/mason/packages/"
local codelldb_path = MASON_PATH .. "codelldb/extension/adapter/codelldb"
local liblldb_path = MASON_PATH .. "codelldb/extension/lldb/lib/liblldb.so"

ui.setup()
vt.setup({})

dap.adapters["pwa-node"] = {
	type = "server",
	host = "::1",
	port = "${port}",
	executable = {
		command = "js-debug-adapter",
		args = {
			"${port}",
		},
	},
}

dap.adapters["lldb"] = {
	type = "executable",
	command = codelldb_path,
}

dap.configurations["typescript"] = {
	{
		type = "pwa-node",
		request = "attach",
		name = "Attach to Node app",
		address = "localhost",
		port = 9229,
		cwd = "${workspaceFolder}",
		restart = true,
	},
}

dap.configurations["rust"] = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
		runInTerminal = true,
	},
}

vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)

vim.keymap.set("n", "<space>?", function()
	require("dapui").eval(nil, { enter = true })
end)

vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F6>", dap.step_into)
vim.keymap.set("n", "<F7>", dap.step_over)
vim.keymap.set("n", "<F8>", dap.step_out)
vim.keymap.set("n", "<a-F7>", dap.step_back)
vim.keymap.set("n", "<a-F8>", dap.terminate)

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end

vim.api.nvim_create_user_command("AddToQuickfix", function()
	local current_location = {
		filename = vim.fn.expand("%:p"),
		lnum = vim.fn.line("."),
		col = vim.fn.col("."),
		text = vim.fn.getline("."),
	}
	vim.fn.setqflist({}, "a", { items = { current_location } })
	print("Added to quickfix list: " .. current_location.filename .. ":" .. current_location.lnum)
end, {})

vim.keymap.set("n", "<leader>q", ":AddToQuickfix<CR>")
