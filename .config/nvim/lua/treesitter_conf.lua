_M = {}

local disable_function = function(lang)
	local buf_name = vim.fn.expand("%")
	if (lang == "cpp" or lang == "c") and string.find(buf_name, "stm32mp157cxx_ca7.h") then
		-- print("Treesitter refactor.highlight_definitions disabled because name matches a known large CMSIS file")
		return true
	end
	local filesize = vim.fn.wordcount()['bytes']
	if (filesize > 1000000) then
		-- print("Treesitter refactor.highlight_definitions disabled because filesize exceeds 1000000B (is "..filesize..")")
		return true
	end
end

_M.config = function()
	local langs = { "cpp", "python", "rust", "regex", "javascript", "css", "bash", "c", "php", "yaml", "lua", "html",
		"latex" }

	require('nvim-treesitter').install(langs, { summary = true })

	for _, lang in ipairs(langs) do
		vim.api.nvim_create_autocmd('FileType', { pattern = { lang }, callback = function() vim.treesitter.start() end, })
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

local old_ts_setup = function()
	require "nvim-treesitter.config".setup {
		auto_install = true,
		highlight = {
			enable = true,
			-- custom_captures = {
			-- 	["template_arg"] = "TSTemplateArg"
			-- },
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm"
			}
		},
		indent = false,
		refactor = {
			highlight_definitions = {
				enable = true,
				disable = disable_function
			},
			highlight_current_scope = { enable = false },
			smart_rename = { enable = true, keymaps = { smart_rename = "<leader>rN" } },
		},
		textobjects = {
			select = {
				enable = true,

				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,

				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>a"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>A"] = "@parameter.inner",
				},
			},
		},
	}
end

return _M
