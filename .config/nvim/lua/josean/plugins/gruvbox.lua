return {
	{
		"morhetz/gruvbox",
		priority = 1000, -- pastikan dipakai duluan
		lazy = false, -- muat saat start
		init = function()
			vim.opt.termguicolors = true -- 24-bit colors (Alacritty OK)
			vim.o.background = "dark" -- atau "light"
			-- Opsi gruvbox (opsional)
			vim.g.gruvbox_contrast_dark = "medium" -- "soft" | "medium" | "hard"
			-- vim.g.gruvbox_italic = 1
			-- vim.g.gruvbox_transparent_bg = 1
		end,
		config = function()
			vim.cmd.colorscheme("gruvbox")
		end,
	},
}
