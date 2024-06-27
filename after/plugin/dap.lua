local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
	controls = {
		element = "repl",
		enabled = true,
		icons = {
			disconnect = "",
			pause = "",
			play = "",
			run_last = "",
			step_back = "",
			step_into = "",
			step_out = "",
			step_over = "",
			terminate = "",
		},
	},
	element_mappings = {},
	expand_lines = true,
	floating = {
		border = "single",
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	force_buffers = true,
	icons = {
		collapsed = "",
		current_frame = "",
		expanded = "",
	},
	layouts = {
		{
			elements = {
				{
					id = "scopes",
					size = 0.25,
				},
				{
					id = "breakpoints",
					size = 0.25,
				},
				{
					id = "stacks",
					size = 0.25,
				},
				{
					id = "watches",
					size = 0.25,
				},
			},
			position = "left",
			size = 40,
		},
		{
			elements = {
				{
					id = "repl",
					size = 0.5,
				},
				{
					id = "console",
					size = 0.5,
				},
			},
			position = "bottom",
			size = 10,
		},
	},
	mappings = {
		edit = "e",
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		repl = "r",
		toggle = "t",
	},
	render = {
		indent = 1,
		max_value_lines = 9000,
	},
})
dap.adapters.go = {
	type = "server",
	host = "127.0.0.1",
	port = 40000,
}
dap.configurations.go = {
	{
		type = "go",
		name = "Debug",
		request = "attach",
		showLog = false,
		program = "${file}",
		mode = "remote",
		dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
	},
}

require("which-key").register({
	d = {
		name = "Debug",
		u = { dapui.toggle, "Toggle dap ui" },
		b = { dap.toggle_breakpoint, "Toggle breakpoint" },
		c = { dap.continue, "Continue debugging" },
		d = { dap.disconnect, "Disconnect from debugee" },
		i = { dap.set_into, "Step into" },
		s = {
			function()
				dapui.float_element("scopes", { enter = true })
			end,
			"Open scopes",
		},
	},
}, { prefix = "<leader>" })
