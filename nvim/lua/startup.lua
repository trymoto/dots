vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		dofile(vim.env.MYVIMRC)
	end,
})
