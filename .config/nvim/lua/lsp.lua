vim.lsp.enable("clangd")
vim.lsp.enable("pyright")
-- vim.lsp.enable("python-language-server")

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		border = 'rounded',
		source = 'always',
		header = '',
		prefix = '',
	},
})
