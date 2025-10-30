-- based on https://github.com/tjdevries/config.nvim

local capabilities = nil
if pcall(require, "cmp_nvim_lsp") then
	capabilities = require("cmp_nvim_lsp").default_capabilities()
end

local servers = {
	bashls = true,

	gopls = {
		settings = {
			gopls = {
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	},

	lua_ls = true,
	rust_analyzer = true,
	templ = true,
	cssls = true,

	ts_ls = {
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	},

	eslint = {
		settings = {
			codeAction = {
				disableRuleComment = {
					enable = true,
					location = "separateLine",
				},
				showDocumentation = {
					enable = true,
				},
			},
			codeActionOnSave = {
				enable = false,
				mode = "all",
			},
			experimental = {
				useFlatConfig = false,
			},
			format = true,
			nodePath = "",
			onIgnoredFiles = "off",
			packageManager = "npm",
			problems = {
				shortenToSingleLine = false,
			},
			quiet = false,
			rulesCustomizations = {},
			run = "onType",
			useESLintClass = false,
			validate = "on",
			workingDirectory = {
				mode = "location",
			},
		},
	},

	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},

	yamlls = {
		settings = {
			yaml = {
				schemaStore = {
					enable = false,
					url = "",
				},
				schemas = require("schemastore").yaml.schemas(),
			},
		},
	},

	clangd = {
		init_options = { clangdFileStatus = true },
		filetypes = { "c" },
	},
}

local servers_to_install = vim.tbl_filter(function(key)
	local t = servers[key]
	if type(t) == "table" then
		return not t.manual_install
	else
		return t
	end
end, vim.tbl_keys(servers))

require("mason").setup()
local ensure_installed = {
	"stylua",
	"lua_ls",
	"gopls",
	"rust_analyzer",
	"bashls",
	"ts_ls",
	"cssls",
	"eslint_d",
	"delve",
}

vim.list_extend(ensure_installed, servers_to_install)
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

for name, config in pairs(servers) do
	if config == true then
		config = {}
	end
	config = vim.tbl_deep_extend("force", {}, {
		capabilities = capabilities,
	}, config)

	vim.lsp.config(name, config)
	vim.lsp.enable(name)
end

local disable_semantic_tokens = {
	lua = true,
}

local null_ls = require("null-ls")

local sources = {
	null_ls.builtins.code_actions.refactoring,
	-- ESLint autofix
	null_ls.builtins.code_actions.eslint_d,
	null_ls.builtins.diagnostics.eslint_d,
}

null_ls.setup({ sources = sources, debug = true })

-- Organize imports for TypeScript/JavaScript
local function organize_imports()
	local clients = vim.lsp.get_clients({ bufnr = 0, name = "ts_ls" })
	if #clients == 0 then
		vim.notify("TypeScript LSP not available", vim.log.levels.WARN)
		return
	end

	local client = clients[1]
	if not client.server_capabilities.executeCommandProvider then
		vim.notify("TypeScript LSP doesn't support executeCommand", vim.log.levels.WARN)
		return
	end

	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
	}

	client.request("workspace/executeCommand", params, function(err, result)
		if err then
			vim.notify("Organize imports failed: " .. (err.message or "Unknown error"), vim.log.levels.ERROR)
		else
			vim.notify("Imports organized", vim.log.levels.INFO)
		end
	end, 0)
end

-- ESLint autofix
local function eslint_fix_all()
	local clients = vim.lsp.get_clients({ bufnr = 0, name = "eslint" })
	if #clients == 0 then
		vim.notify("ESLint LSP not available", vim.log.levels.WARN)
		return
	end

	local client = clients[1]
	local params = {
		command = "eslint.executeAutofix",
		arguments = {
			{
				uri = vim.uri_from_bufnr(0),
				version = vim.lsp.util.buf_versions[vim.api.nvim_get_current_buf()],
			},
		},
	}

	client.request("workspace/executeCommand", params, function(err, result)
		if err then
			vim.notify("ESLint autofix failed: " .. (err.message or "Unknown error"), vim.log.levels.ERROR)
		else
			vim.notify("ESLint autofix completed", vim.log.levels.INFO)
		end
	end, 0)
end

local function ts_build()
	vim.cmd("!npx tsc --build")
end

local function ts_watch()
	vim.cmd("tabnew | terminal npx tsc --watch")
end

local function is_ts_js_file()
	local ft = vim.bo.filetype
	return ft == "typescript" or ft == "javascript" or ft == "typescriptreact" or ft == "javascriptreact"
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

		vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })
		vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
		vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
		vim.keymap.set("x", "<leader>f", vim.lsp.buf.format)

		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

		vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { buffer = 0 })
		vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { buffer = 0 })

		if client.name == "ts_ls" then
			vim.keymap.set("n", "<leader>o", organize_imports, { buffer = bufnr, desc = "Organize Imports" })
			vim.keymap.set("n", "<leader>tb", ts_build, { buffer = bufnr, desc = "TypeScript Build" })
			vim.keymap.set("n", "<leader>tw", ts_watch, { buffer = bufnr, desc = "TypeScript Watch" })
		end

		-- ESLint autofix
		if client.name == "eslint" then
			vim.keymap.set("n", "<leader>lf", eslint_fix_all, { buffer = bufnr, desc = "ESLint Fix All" })

			-- Auto-fix on save (optional - uncomment if desired)
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			-- 	buffer = bufnr,
			-- 	callback = function()
			-- 		if is_ts_js_file() then
			-- 			eslint_fix_all()
			-- 		end
			-- 	end,
			-- })
		end

		local filetype = vim.bo[bufnr].filetype
		if disable_semantic_tokens[filetype] then
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "gofmt", "goimports", "golines" },
		typescript = { "prettier", "eslint_d" },
		tsx = { "prettier", "eslint_d" },
		javascript = { "prettier", "eslint_d" },
		jsx = { "prettier", "eslint_d" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		local filetype = vim.bo[args.buf].filetype
		if
			filetype == "typescript"
			or filetype == "javascript"
			or filetype == "typescriptreact"
			or filetype == "javascriptreact"
		then
			local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "ts_ls" })
			if #clients > 0 then
				organize_imports()
				vim.defer_fn(function()
					require("conform").format({
						bufnr = args.buf,
						lsp_fallback = true,
						quiet = true,
					})
				end, 100)
			else
				require("conform").format({
					bufnr = args.buf,
					lsp_fallback = true,
					quiet = true,
				})
			end
		else
			require("conform").format({
				bufnr = args.buf,
				lsp_fallback = true,
				quiet = true,
			})
		end
	end,
})

vim.api.nvim_create_user_command("TSBuild", ts_build, { desc = "Run TypeScript build" })
vim.api.nvim_create_user_command("TSWatch", ts_watch, { desc = "Run TypeScript watch mode" })
vim.api.nvim_create_user_command("OrganizeImports", organize_imports, { desc = "Organize imports" })
vim.api.nvim_create_user_command("ESLintFix", eslint_fix_all, { desc = "Fix all ESLint issues" })

local cmp = require("cmp")

cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
	},
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
		["<C-j>"] = cmp.mapping.select_next_item({
			behavior = cmp.SelectBehavior.Select,
		}),
		["<C-k>"] = cmp.mapping.select_prev_item({
			behavior = cmp.SelectBehavior.Select,
		}),
		["<ESC>"] = cmp.mapping.abort(),
		["<PageDown>"] = cmp.mapping.scroll_docs(4),
		["<PageUp>"] = cmp.mapping.scroll_docs(-4),
	}),
})

require("refactoring").setup({})

vim.keymap.set({ "n", "x" }, "<leader>rr", function()
	require("refactoring").select_refactor()
end)
