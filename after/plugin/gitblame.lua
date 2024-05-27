local gitblame = require("gitblame")

gitblame.setup({
	enabled = false,
})

vim.keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>", {remap=false})
