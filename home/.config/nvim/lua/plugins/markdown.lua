local config = vim.fn.expand("~/.markdownlint.yaml")

return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters = {
				["markdownlint-cli2"] = {
					prepend_args = { "--config", config },
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters = {
				["markdownlint-cli2"] = {
					prepend_args = { "--config", config },
				},
			},
		},
	},
}
