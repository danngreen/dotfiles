local clangbin = "clangd"

-- Not needed, but might be useful. Why does lua filter out the 4m?
-- if string.find(vim.fn.getcwd(), "vcv/4ms") then
-- 	clangbin = "/Users/dann/bin/clangd_16.0.2/bin/clangd"
-- end

vim.lsp.config('clangd', {
	cmd = {
		clangbin,
		-- "clangd",
		-- "/Users/dann/bin/clangd_18.1.3/bin/clangd",
		-- "/Users/dann/bin/clangd_17.0.3/bin/clangd",
		-- "/Users/dann/bin/clangd_16.0.2/bin/clangd",
		-- "/Users/dann/bin/clangd_snapshot_20240714/bin/clangd",
		-- "/Users/dann/bin/clangd_snapshot_20240721/bin/clangd",
		"--background-index",
		"--log=error",
		-- "--log=verbose",
		"--pretty",
		"-j=1",
		"--fallback-style=LLVM",
		"--clang-tidy",
		"--header-insertion-decorators",
		"--completion-style=bundled",
		"--query-driver=/usr/local/bin/arm-none-eabi-g*",
		"--query-driver=/Users/**/4ms/stm32/*-arm-none-eabi*/bin/arm-none-eabi-*",
		"--query-driver=/Volumes/Studio/bin/*-arm-none-eabi*/bin/arm-none-eabi-*",
		"--query-driver=/Users/**/bin/*-arm-none-eabi*/bin/arm-none-eabi-*",
		"--query-driver=/usr/bin/g*",
		"--query-driver=/usr/local/opt/llvm/bin/clang*",
		"--query-driver=/Users/dann/bin/arm-gnu-toolchain-12.3.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-*",
		"--query-driver=/Users/dann/bin/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-aarch64-none-elf/bin/aarch64-none-elf-*",
		"--query-driver=/Users/dann/Library/Arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/bin/avr-*",
		"--query-driver=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++",
		"--query-driver=/opt/homebrew/opt/llvm/bin/clang",
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

	on_init = function(client, init_result)
		if init_result.offsetEncoding then
			client.offset_encoding = init_result.offsetEncoding
		end
		client.config.allow_incremental_sync = true
		client.config.debounce_text_changes = 100
		-- client.server_capabilities.semanticTokensProvider = nil
	end,
})
