_M = {}


_M.config = function()
	local langs = { "cpp", "python", "rust", "regex", "javascript", "css", "bash", "c", "php", "yaml", "lua", "html",
		"latex" }

	require('nvim-treesitter').install(langs, { summary = true })

	for _, lang in ipairs(langs) do
		vim.api.nvim_create_autocmd('FileType', {
			pattern = { lang },
			callback = function()
				vim.treesitter.start()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				-- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
				-- vim.wo[0][0].foldmethod = 'expr'
			end,
		})
	end

	-- Config textobjects
	vim.g.no_plugin_maps = true

	require("nvim-treesitter-textobjects").setup {
		select = {
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			selection_modes = {
				['@parameter.outer'] = 'v', -- charwise
				['@function.outer'] = 'V', -- linewise
				-- ['@class.outer'] = '<c-v>', -- blockwise
			},
			include_surrounding_whitespace = false,
		},
	}
	vim.keymap.set({ "x", "o" }, "af", function()
		require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "if", function()
		require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "ac", function()
		require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "ic", function()
		require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "as", function()
		require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
	end)
	vim.keymap.set("n", "<leader>a", function()
		require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
	end)
	vim.keymap.set("n", "<leader>A", function()
		require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.outer"
	end)
	vim.keymap.set({ "n", "x", "o" }, "]f", function()
		require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
	end)
	vim.keymap.set({ "n", "x", "o" }, "[f", function()
		require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
	end)
end


----------------------------------------------
---
---
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
