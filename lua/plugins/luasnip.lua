local M = {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"rafamadriz/friendly-snippets", -- optional, falls du vorgefertigte Snippets möchtest
	},
    ft = { "f90", "f95", "f", "for", "f77", "cpp", "py", "tex" }
}

M.config = function()
	local luasnip = require("luasnip")

	-- Deaktiviere LuaSnip für .tex und .bib Dateien
	-- local filetypes_disabled = { "tex", "bib" }
	-- for _, ft in ipairs(filetypes_disabled) do
		-- vim.cmd("autocmd FileType " .. ft .. " setlocal noexpandtab")
	-- end

	-- LuaSnip Konfiguration
	luasnip.setup({
		history = true,
		delete_check_events = "TextChanged",
    enable_autosnippets = true,
	})

	-- Optionale Keymaps für LuaSnip
	local keymap = vim.api.nvim_set_keymap
	local opts = { noremap = true, silent = true }

	keymap("i", "<C-k>", "<cmd>lua require'luasnip'.expand_or_jump()<CR>", opts)
	keymap("s", "<C-k>", "<cmd>lua require'luasnip'.expand_or_jump()<CR>", opts)
	keymap("i", "<C-j>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
	keymap("s", "<C-j>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
end

return M
