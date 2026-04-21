vim.lsp.enable("clangd")
vim.lsp.enable("pyright")
vim.lsp.enable("lua_ls")
vim.lsp.enable("gopls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("cmake")
vim.lsp.enable("ts_ls")

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


-- Format on save
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('lsp.attach', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		-- Format on save
		if client.name ~= "cmake" then
			if client:supports_method('textDocument/formatting') then
				vim.api.nvim_create_autocmd('BufWritePre', {
					group = vim.api.nvim_create_augroup('lsp.attach', { clear = false }),
					buffer = args.buf,
					callback = function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 }) end,
				})
			end
		end

		-- Highlight references to symbol under cursor
		-- LspReferenceText LspReferenceRead LspReferenceWrite
		if client:supports_method('textDocument/documentHighlight') then
			local hl_group = vim.api.nvim_create_augroup('lsp.document_highlight.' .. args.buf, { clear = true })
			vim.api.nvim_create_autocmd({ 'CursorHold' }, {
				group = hl_group,
				buffer = args.buf,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
				group = hl_group,
				buffer = args.buf,
				callback = vim.lsp.buf.clear_references,
			})
			vim.api.nvim_create_autocmd('LspDetach', {
				group = vim.api.nvim_create_augroup('lsp.document_highlight.detach.' .. args.buf, { clear = true }),
				buffer = args.buf,
				callback = function(ev)
					vim.lsp.buf.clear_references()
					pcall(vim.api.nvim_del_augroup_by_name, 'lsp.document_highlight.' .. ev.buf)
				end,
			})
		end
	end,
})



-- Handlers
-- Doesn't have any effect, why?
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.buf.hover({ border = "rounded" })
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.buf.signature_help({ border = "rounded" })
