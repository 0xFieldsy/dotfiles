-- Keymaps are automatically loaded on the VeryLazy event.
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- LazyVim already maps <C-s> to save in every mode.
vim.keymap.set({ "n", "i", "x", "s" }, "<C-q>", "<cmd>q!<cr>", { desc = "Quit without saving" })

-- Like Helix, U redoes.
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- Like Helix, delete or change without copying to a register or the system clipboard.
vim.keymap.set({ "n", "x" }, "<M-d>", '"_d', { desc = "Delete without yanking" })
vim.keymap.set({ "n", "x" }, "<M-c>", '"_c', { desc = "Change without yanking" })

-- Like Helix, yank and paste with the system clipboard.
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste clipboard after" })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste clipboard before" })

-- In visual mode, paste without copying the selection to a register or the system clipboard.
vim.keymap.set("x", "p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set("x", "P", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set("x", "<leader>p", '"_d"+P', { desc = "Paste clipboard over selection" })
vim.keymap.set("x", "<leader>P", '"_d"+P', { desc = "Paste clipboard over selection" })
