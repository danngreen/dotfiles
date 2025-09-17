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
		local files = vim.api.nvim_get_runtime_file("lsp/clangd.lua", true)
		-- TODO: try all files but skip the one that's this file
		if #files > 0 then
			local upstream_attach = dofile(files[#files]).on_attach
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
