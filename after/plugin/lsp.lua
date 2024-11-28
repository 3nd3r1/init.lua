local lsp = require("lsp-zero")

lsp.preset("recommended")

-- Linting
require("lint").linters_by_ft = {
	python = { "pylint" },
	yaml = { "yamllint" },
}
require("mason-nvim-lint").setup()

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

-- Completions
local cmp = require("cmp")

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		-- `Enter` key to confirm completion
		["<Tab>"] = cmp.mapping.confirm({ select = true }),

		-- Ctrl+Space to trigger completion menu
		["<C-c>"] = cmp.mapping.complete(),

		-- Navigate between completions
		["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.select }),
		["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.select }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
	}, { { name = "buffer" } }),
	formatting = {
		format = require("lspkind").cmp_format({
			mode = "symbol_text",
			preset = "codicons",
			maxwidth = 50,
			ellipsis_char = "...",
		}),
	},
})

-- LSP
lsp.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	require("which-key").add({
		buffer = bufnr,
		{ "<leader>l", group = "LSP" },
		{ "<leader>K", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Show hover information" },
		{ "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Go to definition" },
		{ "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Go to declaration" },
		{ "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Go to implementation" },
		{ "<leader>lo", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Go to type definition" },
		{ "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Show references" },
		{ "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Show signature help" },
		{ "<leader><F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename symbol" },
		{ "<leader><F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code action" },
		{ "<leader>lx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
	})
end)

lsp.set_server_config({
	on_init = function(client)
		client.server_capabilities.semanticTokensProvider = nil
	end,
})

-- Mason
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pyright",
		"ts_ls",
		"html",
		"yamlls",
		"helm_ls",
		"bashls",
		"gopls",
	},
	handlers = {
		lsp.default_setup,
		lua_ls = function()
			local lua_opts = lsp.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)
		end,
		helm_ls = function()
			require("lspconfig").helm_ls.setup({
				settings = {
					["helm-ls"] = {
						valuesFiles = {
							mainValuesFile = "values.yaml",
							lintOverlayValuesFile = "values.lint.yaml",
							additionalValuesFilesGlobPattern = "values.*.yaml",
						},
						yamlls = {
							enabled = true,
							diagnosticsLimit = 50,
							path = "yaml-language-server",
							showDiagnosticsDirectly = false,
							config = {
								schemas = {
									kubernetes = "templates/**",
								},
								completion = true,
								hover = true,
							},
						},
					},
				},
			})
		end,
		yamlls = function()
			require("lspconfig").yamlls.setup({
				on_attach = function(client, bufnr)
					local filename = vim.api.nvim_buf_get_name(bufnr)
					if filename:match("charts/.+/templates/.+%.ya?ml$") then
						vim.defer_fn(function()
							vim.lsp.buf_detach_client(bufnr, client.id)
						end, 100)
					end
				end,
			})
		end,
		gopls = function()
			require("lspconfig").gopls.setup({
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
					},
				},
			})
		end,
		denols = function()
			require("lspconfig").denols.setup({
				root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
			})
		end,
		ts_ls = function()
			require("lspconfig").ts_ls.setup({
				root_dir = function(fname)
					local util = require("lspconfig").util
					local root = util.root_pattern("package.json")(fname)
					-- If there deno.json and package.json, its deno project
					if root and not util.path.is_file(root .. "/deno.json") then
						return root
					end
					return nil
				end,
				single_file_support = false,
			})
		end,
	},
})

-- Formatter
local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		scss = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", stop_after_first = true },
		robot = { "robotidy" },
		go = { "gofmt", "goimports" },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
	},
	formatters = {
		dockfmt = {
			inherit = false,
			command = "/usr/local/bin/dockfmt",
			args = { "fmt", "$FILENAME" },
		},
		robotidy = {
			inherit = false,
			command = "robotidy",
			args = function()
				local fp = io.open(os.getenv("HOME") .. "/.robotidy.toml", "r")
				if fp ~= nil then
					io.close(fp)
					return { "--config", os.getenv("HOME") .. "/.robotidy.toml", "$FILENAME", "--overwrite" }
				else
					return { "$FILENAME", "--overwrite" }
				end
			end,
			range_args = function(self, ctx)
				local fp = io.open(os.getenv("HOME") .. "/.robotidy.toml", "r")
				if fp ~= nil then
					io.close(fp)
					return {
						"--startline",
						ctx.range["start"][1],
						"--endline",
						ctx.range["end"][1],
						"--config",
						os.getenv("HOME") .. "/.robotidy.toml",
						"$FILENAME",
						"--overwrite",
					}
				else
					return {
						"--startline",
						ctx.range["start"][1],
						"--endline",
						ctx.range["end"][1],
						"$FILENAME",
						"--overwrite",
					}
				end
			end,
			stdin = false,
		},
	},
})

require("which-key").add({
	{
		mode = "n",
		{
			"<leader>f",
			function()
				conform.format({
					lsp_format = "fallback",
				})
			end,
			desc = "Format code",
		},
	},
	{
		mode = "v",
		{
			"<leader>f",
			function()
				conform.format({
					lsp_format = "fallback",
				})
			end,
			desc = "Format code",
		},
	},
})
