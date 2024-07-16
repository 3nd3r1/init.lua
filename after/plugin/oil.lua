require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})

require("which-key").add({ { "<leader>pv", "<CMD>Oil<CR>", desc = "Open Oil" } })
