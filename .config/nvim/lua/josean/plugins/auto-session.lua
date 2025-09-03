return {
	"rmagatti/auto-session",

	-- Pastikan sessionoptions sudah memasukkan 'localoptions' sebelum plugin dipanggil
	init = function()
		vim.opt.sessionoptions:append("localoptions")
	end,

	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			-- ganti nama opsi lama -> baru
			auto_restore = false,
			suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },

			-- opsional: matikan command legacy "Session*"/"Autosession"
			-- legacy_cmds = false,
		})

		local keymap = vim.keymap
		-- Migrasi keymap ke command baru
		keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "Restore session for cwd" })
		keymap.set("n", "<leader>ws", "<cmd>AutoSession save<CR>", { desc = "Save session for cwd" })
		-- opsional enak:
		-- keymap.set("n", "<leader>wa", "<cmd>AutoSession toggle<CR>", { desc = "Toggle autosave" })
		-- keymap.set("n", "<leader>wl", "<cmd>AutoSession search<CR>", { desc = "Session picker" })
	end,
}
