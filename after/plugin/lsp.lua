local lsp = require("lsp-zero")

lsp.preset("recommended")

-- Linting
require("lint").linters_by_ft = {
	python = { "pylint", "flake8" },
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
local cmp_action = require("lsp-zero").cmp_action()

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
})

-- LSP
lsp.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	client.server_capabilities.semanticTokensProvider = nil
	require("which-key").register({
		l = {
			name = "LSP",
			K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover information" },
			d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
			D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration" },
			i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation" },
			o = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to type definition" },
			r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Show references" },
			s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Show signature help" },
			["<F2>"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol" },
			["<F4>"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code action" },
			l = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Show diagnostics" },
			["]"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Go to previous diagnostic" },
			["["] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Go to next diagnostic" },
		},
	}, { prefix = "<leader>", buffer = bufnr })

	if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
		vim.diagnostic.enable(false)
	else
		vim.diagnostic.enable(true)
	end
end)

-- Mason
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pyright",
		"tsserver",
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
						yamlls = {
							path = "yaml-language-server",
						},
					},
				},
			})
		end,
	},
})

-- Copilot

vim.keymap.set("i", "<C-Space>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
	desc = "Accept Copilot completion",
})
vim.g.copilot_no_tab_map = true

-- Formatter
local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		javascript = { { "prettierd", "prettier" } },
		javascriptreact = { { "prettierd", "prettier" } },
		typescript = { { "prettierd", "prettier" } },
		typescriptreact = { { "prettierd", "prettier" } },
		html = { { "prettierd", "prettier" } },
		yaml = { { "prettierd", "prettier" } },
		robot = { "robotidy" },
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
                local fp=io.open("$HOME/.robotidy.yaml","r")
                if fp~=nil then
                    io.close(fp)
                    return { "--config", "$HOME/.robotidy.yaml", "$FILENAME", "--overwrite" }
                else
                    return { "$FILENAME", "--overwrite" }
                end
            end,
			range_args = function(self, ctx)
				return { "--startline", ctx.range.start[1], "--endline", ctx.range["end"][1] }
			end,
			stdin = false,
		},
	},
})

require("which-key").register({
	f = {
		function()
			conform.format({
				lsp_format = "fallback",
			})
		end,
		"Format code",
	},
}, { prefix = "<leader>", mode = "n" })

require("which-key").register({
	f = {
		function()
			conform.format({
				lsp_format = "fallback",
			})
		end,
		"Format code",
	},
}, { prefix = "<leader>", mode = "v" })
