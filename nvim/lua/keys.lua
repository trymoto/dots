local keyset = vim.keymap.set
function _G.check_back_space()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

keyset("n", "<A-[>", ":tabprevious<cr>")
keyset("n", "<A-]>", ":tabnext<cr>")

keyset("n", "<C-w>d", ":vsplit<cr><C-w>w")

keyset("n", "<C-t>", ":tabnew<cr>")
keyset("n", "<leader>b", ":NERDTreeToggle<cr>")
keyset("n", "<A-/>", "<Plug>CommentaryLine")
keyset("v", "<A-/>", "<Plug>Commentary")
keyset("n", "<leader>v", ":e $MYVIMRC<cr>")
keyset("n", "<leader>vr", ":source $MYVIMRC<cr>")

vim.env.FZF_DEFAULT_COMMAND =
	'rg --files --hidden --no-ignore --glob "!.git/*" --glob "!dist/*" --glob "!node_modules/*"'
keyset("n", "<c-p>", ":Files<cr>")
keyset("n", "<c-a-p>", ":Rg<cr>")

keyset("n", "<F3>", ":horizontal botright copen 5<cr>")
keyset("n", "<F4>", ":cclose<cr>")
keyset("n", "z0", ":set foldlevel=0<cr>")
keyset("n", "z1", ":set foldlevel=1<cr>")
keyset("n", "z2", ":set foldlevel=2<cr>")
keyset("n", "z3", ":set foldlevel=3<cr>")

keyset("n", "<a-j>", ":m .+1<cr>==")
keyset("n", "<a-k>", ":m .-2<cr>==")
keyset("i", "<a-j>", "<Esc>:m .+1<cr>==gi")
keyset("i", "<a-k>", "<Esc>:m .-2<cr>==gi")
keyset("v", "<a-j>", ":m '>+1<cr>gv=gv")
keyset("v", "<a-k>", ":m '<-2<cr>gv=gv")
keyset("n", "<leader>cp", ":let @+ = expand('%')<cr>")
keyset("n", "<leader>cpa", ":let @+ = expand('%:p')<cr>")
keyset("n", "<Esc><Esc>", ":noh<return><esc>")

keyset("n", "<C-Down>", ":call vm#commands#add_cursor_down(0, 0)<cr>")
keyset("n", "<C-Up>", ":call vm#commands#add_cursor_up(0, 0)<cr>")

keyset(
	"n",
	"<leader>n",
	":VMSearch ^<CR>:call vm#commands#find_all(0, 1)<CR>:call b:VM_Selection.Global.change_mode(1)<CR>"
)

vim.g.VM_maps = {
	["Add Cursor Down"] = "<C-j>",
	["Add Cursor Up"] = "<C-k>",
}

keyset("n", "piw", "ciw<c-r>0<Esc>")
vim.api.nvim_create_user_command("Q", "windo bd", { bang = false, nargs = 0 })

keyset("n", "O", "O<Esc>^d$")
keyset("n", "<leader>e<cr>", ":Ex")
