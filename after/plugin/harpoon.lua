local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

require("which-key").register({
	h = {
        name = "Harpoon",
		a = { mark.add_file, "Add file to harpoon" },
		e = { ui.toggle_quick_menu, "Open harpoon menu" },
		["1"] = {
			function()
				ui.nav_file(1)
			end,
			"Navigate to file 1 in harpoon",
		},
		["2"] = {
			function()
				ui.nav_file(2)
			end,
			"Navigate to file 2 in harpoon",
		},
		["3"] = {
			function()
				ui.nav_file(3)
			end,
			"Navigate to file 3 in harpoon",
		},
		["4"] = {
			function()
				ui.nav_file(4)
			end,
			"Navigate to file 4 in harpoon",
		},
	},
}, { prefix = "<leader>" })
