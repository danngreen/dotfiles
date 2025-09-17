local clangdbin = "clangd"

-- Use this to use a different clangd version for a particular project:
-- if string.find(vim.fn.getcwd(), "vcv/4ms") then
-- 		clangdbin = "/Users/dann/bin/clangd_18.1.3/bin/clangd",
-- 		clangdbin = "/Users/dann/bin/clangd_17.0.3/bin/clangd",
-- 		clangdbin = "/Users/dann/bin/clangd_16.0.2/bin/clangd",
-- end

vim.lsp.config('clangd', {
	cmd = {
		clangdbin,
		"--background-index",
		"--log=error",
		-- "--log=verbose",
		"--pretty",
		"-j=1",
		"--fallback-style=LLVM",
		"--clang-tidy",
		"--header-insertion-decorators",
		"--completion-style=bundled",
		"--query-driver=**/bin/arm-none-eabi-g*",
		"--query-driver=/usr/bin/g*",
		"--query-driver=**/bin/aarch64-none-elf-*",
		"--query-driver=**/bin/avr-*",
		"--query-driver=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++",
		"--query-driver=**/llvm/bin/clang",
		"--pch-storage=memory",
		"--enable-config"
	},
	root_markers = {
		'compile_commands.json',
		'build/compile_commands.json',
		'.clangd',
		'.clang-tidy',
		'.clang-format',
		'compile_flags.txt',
		'configure.ac',
		'.git',
	},
	on_attach = function(client, bufnr)
		-- This is a complicated way to call the on_attach function in nvim-lspconfig/lsp/clangd.lua
		-- because that file defines LspClangdSwitchSourceHeader, which we want to map to a key.

		-- First, get paths to all files named lsp/clangd.lua in our runtime path
		local files = vim.api.nvim_get_runtime_file("lsp/clangd.lua", true)

		-- Find just the one that's in nvim-lspconfig
		local upstream_file = nil
		for _, f in ipairs(files) do
			if f:match("nvim%-lspconfig") then
				upstream_file = f
				break
			end
		end

		-- If we found it, then call the file (dofile) and call the on_attach that it returns
		if upstream_file then
			local upstream_attach = dofile(upstream_file).on_attach
			if upstream_attach then
				upstream_attach(client, bufnr)
				vim.keymap.set("n", "<M-h>", "<cmd>LspClangdSwitchSourceHeader<CR>", { buffer = bufnr })
			end
		end
	end,
	on_init = function(client, init_result)
		if init_result.offsetEncoding then
			client.offset_encoding = init_result.offsetEncoding
		end

		client.config.allow_incremental_sync = true
		client.config.debounce_text_changes = 100
		-- client.server_capabilities.semanticTokensProvider = nil

		-- Does not work to modify clangdbin here:
		-- if string.find(client.root_dir, "vcv/4ms") then
		-- 	clangdbin = "/Users/dann/bin/clangd_16.0.2/bin/clangd"
		-- end
	end,
})
