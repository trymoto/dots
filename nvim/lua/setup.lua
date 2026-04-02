require("mason").setup()
require("mason-lspconfig").setup()

require("scrollbar").setup()
require("nvim-surround").setup({
	surrounds = {
		["l"] = {
			add = { "[[", "]]" },
			find = "%[%[.-%]%]",
			delete = "^(%[%[)().-(%]%])()$",
		},
	},
})
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

-- telescope
require("telescope").setup({
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = "move_selection_next",
				["<C-k>"] = "move_selection_previous",
				["<C-h>"] = "which_key",
				["<PageUp>"] = "preview_scrolling_up",
				["<PageDown>"] = "preview_scrolling_down",
				["<C-q>"] = "send_selected_to_qflist",
			},
		},
		file_ignore_patterns = {
			"node_modules",
			"%.git/*",
		},
	},
	pickers = {
		find_files = {
			hidden = true,
		},
	},
})
require("telescope").load_extension("fzf")

require("obsidian").setup({
	workspaces = {
		{
			name = "meta",
			path = "~/obsidian/meta",
		},
	},
	notes_subdir = "input",
	templates = {
		folder = "templates",
		date_format = "%Y-%m-%d",
		time_format = "%H:%M",
	},
	template = "simple.md",
	daily_notes = {
		-- Optional, if you keep daily notes in a separate directory.
		folder = "input/journal",
		-- Optional, if you want to change the date format for the ID of daily notes.
		-- date_format = "%Y-%M-%D",
		-- Optional, if you want to change the date format of the default alias of daily notes.
		-- alias_format = "%B %-d, %Y",
		-- Optional, default tags to add to each new daily note created.
		-- default_tags = { "daily-notes" },
		-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
		template = "simple.md",
	},
	new_notes_location = "current_dir",
	-- disable_frontmatter = true,
	note_frontmatter_func = function(note)
		-- Add the title of the note as an alias.
		if note.title then
			note:add_alias(note.title)
		end

		local filename = note.path.name:gsub("%.md$", "")
		local is_date = string.match(filename, "^%d%d%d%d%-%d%d%-%d%d$")

		local id = note.id

		if id == filename or not id then
			local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
			local random_id = {}
			math.randomseed(os.time() + os.clock() * 1000000)
			for i = 1, 8 do
				local rand_index = math.random(1, #chars)
				table.insert(random_id, chars:sub(rand_index, rand_index))
			end
			id = tostring(table.concat(random_id))
		end

		local created_at = os.date("%Y-%m-%d")

		if is_date then
			created_at = filename
		end

		local out = {
			id = id,
			created_at = created_at,
		}

		-- `note.metadata` contains any manually added fields in the frontmatter.
		-- So here we just make sure those fields are kept in the frontmatter.
		if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
			for k, v in pairs(note.metadata) do
				out[k] = v
			end
			-- for k, v in pairs(note) do
			-- 	out[k] = v
			-- end
		end

		local is_modified = vim.bo.modified
		if is_modified then
			out.updated_at = os.date("%Y-%m-%d")
		end

		return out
	end,

	follow_url_func = function(url)
		vim.fn.jobstart({ "xdg-open", url }) -- linux
	end,
	follow_img_func = function(img)
		vim.fn.jobstart({ "xdg-open", url }) -- linux
	end,
	ui = {
		-- enable = false,
	},
	picker = {
		-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
		name = "telescope.nvim",
		-- -- Optional, configure key mappings for the picker. These are the defaults.
		-- -- Not all pickers support all mappings.
		-- note_mappings = {
		--   -- Create a new note from your query.
		--   new = "<C-x>",
		--   -- Insert a link to the selected note.
		--   insert_link = "<C-l>",
		-- },
		-- tag_mappings = {
		--   -- Add tag(s) to current note.
		--   tag_note = "<C-x>",
		--   -- Insert a tag at the current location.
		--   insert_tag = "<C-l>",
		-- },
	},
	attachments = {
		-- The default folder to place images in via `:ObsidianPasteImg`.
		-- If this is a relative path it will be interpreted as relative to the vault root.
		-- You can always override this per image by passing a full path to the command instead of just a filename.
		img_folder = "assets/imgs", -- This is the default

		-- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
		---@return string
		-- img_name_func = function()
		--   -- Prefix image names with timestamp.
		--   return string.format("%s-", os.time())
		-- end,

		-- A function that determines the text to insert in the note when pasting an image.
		-- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
		-- This is the default implementation.
		---@param client obsidian.Client
		---@param path obsidian.Path the absolute path to the image file
		---@return string
		-- img_text_func = function(client, path)
		--   path = client:vault_relative_path(path) or path
		--   return string.format("![%s](%s)", path.name, path)
		-- end,
	},
	-- Optional, customize how note IDs are generated given an optional title.
	---@param title string|?
	---@return string
	note_id_func = function(title)
		-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
		-- In this case a note with the title 'My new note' will be given an ID that looks
		-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
		local suffix = ""
		if title ~= nil then
			-- If title is given, transform it into valid file name.
			-- suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			suffix = title
		else
			-- If title is nil, just add 4 random uppercase letters to the suffix.
			for _ = 1, 4 do
				suffix = suffix .. string.char(math.random(65, 90))
			end
		end
		return suffix
	end,
})

-- function to move current file from its location to one of the folders in cwd
-- prioritizing perm, input, journal, dreams, archive
vim.api.nvim_create_user_command("ObsidianRelocate", function()
	local priority_folders = { "perm", "input", "journal", "dreams", "archive" }

	-- collect possible folders (maximum depth 3)
	local possible_folders = {}

	local function collect_folders(path, depth)
		if depth > 3 then
			return
		end

		local items = vim.fn.readdir(path, function(name)
			return vim.fn.isdirectory(path .. "/" .. name) == 1
		end)

		for _, name in ipairs(items) do
			table.insert(possible_folders, name)
			collect_folders(path .. "/" .. name, depth + 1)
		end
	end

	collect_folders(vim.fn.getcwd(), 1)

	-- provide picker to select folder
	-- prioritize folders in priority_folders
	local folders = {}
	for _, folder in ipairs(priority_folders) do
		if vim.tbl_contains(possible_folders, folder) then
			table.insert(folders, folder)
		end
	end
	for _, folder in ipairs(possible_folders) do
		if not vim.tbl_contains(folders, folder) then
			table.insert(folders, folder)
		end
	end

	if #folders == 0 then
		print("No folders found")
		return
	end

	-- Use Telescope picker
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "Move note to folder",
			finder = finders.new_table({
				results = folders,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local target_folder = selection[1]

					-- move current note to target_folder
					local current_path = vim.fn.expand("%:p")
					local filename = vim.fn.expand("%:t")
					local target_path = vim.fn.getcwd() .. "/" .. target_folder .. "/" .. filename

					local success, err = os.rename(current_path, target_path)
					if not success then
						print("Error moving file: " .. tostring(err))
						return
					end

					-- Update buffer to new location
					vim.cmd("edit " .. target_path)

					print("Moved note to " .. target_folder)
				end)
				return true
			end,
		})
		:find()
end, {})

-- bind to <leader>l
vim.keymap.set("n", "<leader>l", ":ObsidianRelocate<CR>")
