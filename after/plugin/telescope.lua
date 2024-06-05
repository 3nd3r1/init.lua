local builtin = require("telescope.builtin")

require("which-key").register({
	p = {
		name = "Telescope",
		f = { builtin.find_files, "Find files" },
		g = { builtin.git_files, "Find git files" },
		t = { builtin.treesitter, "Treesitter find" },
		s = {
			function()
				builtin.live_grep({ additional_args = { "--hidden" } })
			end,
			"Live grep",
		},
	},
}, { prefix = "<leader>" })
