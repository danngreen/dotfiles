--F5 dirname must be an abs path?
--formatoptions gets cleared/reset by some plugin?

require "plugins"
require "keys"
require "lsp"
-- require "cmp-conf"

--Options
vim.o.makeprg = "make -j16"
vim.o.encoding = "UTF-8" -- Do we need this?
vim.o.showmode = false
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
vim.o.hlsearch = true
vim.wo.number = true
vim.o.hidden = true
vim.o.mouse = "a"
vim.o.splitright = true
vim.o.startofline = false
vim.o.swapfile = false
vim.o.backspace = "indent,eol,start"
vim.o.magic = true -- regular expressions
vim.o.incsearch = true
vim.o.inccommand = "nosplit"
vim.o.listchars = "eol:⏎,tab:| ,trail:*,nbsp:⎵,space:."
vim.o.cmdheight = 1
vim.o.updatetime = 300
vim.o.timeoutlen = 600
vim.wo.signcolumn = "yes"
vim.opt.shortmess:append("c") -- Avoid showing message extra message when using completion
vim.opt.shortmess:remove("F")
vim.o.wildmenu = true
vim.opt.wildignore:append { "tags,tags.*,build/*" }
vim.o.path = ".,,**"

--Set these last, some plugin overrides them. TODO: which one?
vim.o.formatoptions = vim.o.formatoptions .. "n" --Format lists
vim.opt.formatoptions:remove "r"                 -- Don't insert comment leader after pressing <Enter>
vim.opt.formatoptions:remove "o"                 -- Don't insert comment leader after pressing o or O
vim.wo.number = true

-- Which of these works?
vim.opt.diffopt:append { "linematch:60" }
vim.cmd [[set diffopt+=linematch:60]]


-- Display
vim.o.guifont = "Inconsolata_Regular_Nerd_Font_Complete_Mono:h13"
vim.o.termguicolors = true
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait1-blinkon150-blinkoff50"
vim.api.nvim_exec(
	[[augroup textyankpost
	autocmd!
	au TextYankPost * lua vim.highlight.on_yank {on_visual = true}
	augroup end]],
	false
)


vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { ".clangd" },
	command = "set syntax=yaml"
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf" },
	command = "set nobuflisted",
	desc = "Hide quickfix from buffer list"
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*/nvim/init.lua", "*/nvim/lua/keys.lua" },
	command = "luafile %",
	desc = "Immediately apply changes on save"
})

vim.cmd [[set exrc]]

vim.on_key(function(char)
	if vim.fn.mode() == "n" then
		vim.opt.hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
	end
end, vim.api.nvim_create_namespace "auto_hlsearch")
