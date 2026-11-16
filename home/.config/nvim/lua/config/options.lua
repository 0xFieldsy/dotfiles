-- Options are automatically loaded before lazy.nvim startup.
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Override language servers.
vim.g.lazyvim_python_lsp = "ty"
vim.g.lazyvim_ts_lsp = "tsc"

-- Force OSC 52 like Helix.
if not vim.env.TMUX and not vim.env.DISPLAY and not vim.env.WAYLAND_DISPLAY then
	local osc52 = require("vim.ui.clipboard.osc52")
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = osc52.copy("+"),
			["*"] = osc52.copy("*"),
		},
		paste = {
			["+"] = osc52.paste("+"),
			["*"] = osc52.paste("*"),
		},
	}
end

-- Wrap around the end of the line like Helix.
vim.opt.whichwrap:append("<,>,h,l,[,]")

-- Render boundary whitespace.
vim.opt.list = true
vim.opt.listchars = { tab = "  ", lead = "·", trail = "·", multispace = "·" }

-- Pin the background so Neovim removes its OSC 11 handler on VimEnter.
vim.opt.background = "light"
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = "TermResponse", group = "nvim.tty" })) do
			if autocmd.desc and autocmd.desc:find("background", 1, true) then
				vim.api.nvim_del_autocmd(autocmd.id)
			end
		end
		vim.opt.background = "light"
	end,
})
