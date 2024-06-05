require("which-key").register({
    g = {
        name = "Git",
        s = {
            function()
                vim.cmd.Git()
            end,
            "Open fugitive",
        },
    },
}, { prefix = "<leader>" })

local Fugitive = vim.api.nvim_create_augroup("Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
	group = Fugitive,
	pattern = "*",
	callback = function()
		if vim.bo.ft ~= "fugitive" then
			return
		end

		local bufnr = vim.api.nvim_get_current_buf()
		require("which-key").register({
			g = {
				name = "Git",
				P = {
					function()
						vim.cmd.Git("push")
					end,
					"Push",
				},
				p = {
					function()
						vim.cmd.Git("pull --rebase")
					end,
					"Pull rebase",
				},
				t = {
					function()
						vim.cmd.Git("push -u origin ")
					end,
					"Push to origin",
				},
			},
		}, { prefix = "<leader>", buffer = bufnr })
	end,
})
