-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Colorscheme
	-- use({
	--    'Shatur/neovim-ayu',
	--    as = 'ayu',
	--    config = function()
	--        vim.cmd('colorscheme ayu');
	--    end
	-- })

	use("theprimeagen/harpoon")
	use("mbbill/undotree")
	use("tpope/vim-fugitive")
	use("rcarriga/nvim-notify")
	use("nvim-tree/nvim-web-devicons")
	use("lambdalisue/suda.vim")

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})
	use({
		"goolord/alpha-nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	})
	use("f-person/git-blame.nvim")
	use("stevearc/oil.nvim")

	use("folke/which-key.nvim")

	-- LSP STUFF -----------------------------------------------------------------------------------------------------
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })

	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } })

	use({
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup()
		end,
	})

	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		requires = {
			--- Uncomment the two plugins below if you want to manage the language servers from neovim
			--- and read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "towolf/vim-helm", ft = "helm" },
			"hrsh7th/cmp-buffer",

			-- Linting
			{ "mfussenegger/nvim-lint" },
			{ "rshkarin/mason-nvim-lint" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
			"onsails/lspkind.nvim",

			-- formatting
			"stevearc/conform.nvim",

			-- copilot
			"github/copilot.vim",

			-- codium
			{ "Exafunction/windsurf.vim"},
		},
	})
end)
