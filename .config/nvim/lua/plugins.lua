vim.g.mapleader = ","
vim.g.localmapleader = ","

-- Must be set before barbar's plugin/ file loads
vim.g.barbar_auto_setup = false

-- Order matters: list dependencies before dependents.
vim.pack.add({
	-- Core dependencies
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/nvim-lua/popup.nvim',
	'https://github.com/nvim-tree/nvim-web-devicons',
	'https://github.com/MunifTanjim/nui.nvim',

	-- Treesitter (core must come before extensions)
	'https://github.com/nvim-treesitter/nvim-treesitter',
	'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',

	-- UI
	{ src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = 'v2.x' },
	'https://github.com/vijaymarupudi/nvim-fzf',
	'https://github.com/ibhagwan/fzf-lua',
	'https://github.com/danngreen/monokai.nvim',
	'https://github.com/danngreen/lualine.nvim',
	'https://github.com/rcarriga/nvim-notify',
	'https://github.com/stevearc/dressing.nvim',
	'https://github.com/MeanderingProgrammer/markdown.nvim',
	'https://github.com/romgrk/barbar.nvim',

	-- Editing
	'https://github.com/kylechui/nvim-surround',
	'https://github.com/majutsushi/tagbar',
	'https://github.com/tpope/vim-commentary',
	'https://github.com/tpope/vim-eunuch',
	'https://github.com/tpope/vim-dispatch',
	'https://github.com/voldikss/vim-floaterm',
	'https://github.com/mbbill/undotree',
	'https://github.com/fidian/hexmode',
	--
	-- Git
	'https://github.com/tpope/vim-fugitive',
	'https://github.com/lewis6991/gitsigns.nvim',
	{ src = 'https://github.com/danngreen/gitgraph.nvim',     version = 'experiment' },
	'https://github.com/sindrets/diffview.nvim',

	-- LSP / Completion
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/hrsh7th/nvim-cmp',
	'https://github.com/hrsh7th/vim-vsnip',
	'https://github.com/hrsh7th/cmp-nvim-lua',
	'https://github.com/hrsh7th/cmp-buffer',
	'https://github.com/hrsh7th/cmp-nvim-lsp',
	'https://github.com/hrsh7th/cmp-path',
	'https://github.com/hrsh7th/cmp-calc',
	'https://github.com/uga-rosa/cmp-dictionary',
	'https://github.com/williamboman/mason.nvim',

	'https://github.com/sqwxl/playdate.nvim',

	'https://github.com/krady21/compiler-explorer.nvim',
	'https://github.com/p00f/godbolt.nvim',
	'https://github.com/audiobird/nvim-skipinc',
}, { load = true })

-- How to use local plugins:
-- comment out of vim.pack.add(...)
-- Put plugin in ~/.local/share/nvim/site/pack/mine/opt
-- call vim.cmd.packadd('my-local-copy')

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require("fzf-lua").setup(require("fzf-lua-conf").config)

require("monokai").setup { custom_hlgroups = require("custom-hi").groups }
require("custom-hi").do_hl()

require("lualine").setup(require("lualine-conf").config)

require("nvim-surround").setup()
require("skipinc").setup()

require("notify").setup({ render = "minimal", stages = "static" })
vim.notify = require("notify")

require("render-markdown").setup({
	debounce = 400,
	code = {
		style = 'full',
		border = 'thick',
	},
})

require("barbar").setup({
	icons = {
		button = 'X',
		filetype = { enabled = false },
	},
	focus_on_close = 'previous',
	hide = { current = false },
})

require("gitgraph").setup({
	symbols = {
		merge_commit = 'M',
		commit = '*',
		fallback_remote_icon = "■",
	},
	format = {
		timestamp = '%d-%m-%Y %H:%M ',
		fields = { 'timestamp', 'hash', 'author', 'message' },
		fields2 = { 'tag', 'branch_name' },
		remotes = {
			{ server = "origin", icon = "■", highlight = "SpecialKey" },
			{ server = "danngreen", icon = "■", highlight = "QuickFixLine" },
			{ server = "upstream", icon = "▤", highlight = "QuickFixLine" },
			{ server = "", icon = "○", highlight = "" },
		},
	},
	hooks = {
		on_select_commit = function(commit)
			vim.notify('DiffviewOpen ' .. commit.hash .. '^!')
			vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
		end,
		on_select_range_commit = function(from, to)
			vim.notify('DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
			vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
		end,
	},
})
-- Moved from Lazy `keys` spec:
vim.keymap.set('n', '<F6>', function()
	require('gitgraph').draw({}, { all = true, max_count = 5000 })
end, { desc = "GitGraph - Draw" })

require("cmp").setup(require("cmp-conf").config)

require("mason").setup()

require("playdate").setup({
	playdate_sdk_path = "/Users/dann/Developer/PlaydateSDK",
	playdate_luacats_path = "/Users/dann/playdate/playdate-luacats",
	build = {
		source_dir = "source",
		output_dir = "build.pdx",
	},
	server_settings = {},
})

vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == 'nvim-treesitter' and kind == 'update' then
			if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
			vim.cmd('TSUpdate')
		end
	end
})
require("treesitter_conf").config()

vim.g.tagbar_file_size_limit = 400000

--TODO: treesitter indents?

vim.cmd [[
augroup commentary_c_cpp_php
	autocmd!
	autocmd FileType c setlocal commentstring=//%s
	autocmd FileType cpp setlocal commentstring=//%s
	autocmd FileType php setlocal commentstring=//%s
augroup END
]]

vim.cmd([[set undodir=$HOME/.cache/nvim/undotree]])
vim.cmd([[set undofile]])

require("gitsigns").setup()

require("godbolt").setup(require("godbolt-conf").config)
