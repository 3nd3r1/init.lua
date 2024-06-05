local gitblame = require("gitblame")

gitblame.setup({
	enabled = false,
})

require("which-key").register({
	g = {
		name = "Git",
		b = { gitblame.toggle, "Toggle Git Blame" },
	},
}, { prefix = "<leader>" })
