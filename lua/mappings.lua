require "nvchad.mappings"

-- File Explorer (NvimTree)
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Common Key Mappings
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Save File
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })

-- DAP (Debug Adapter Protocol) Key Mappings
local dap = require "dap"

map("n", "<F5>", function() dap.continue() end, { desc = "DAP Continue" })
map("n", "<F10>", function() dap.step_over() end, { desc = "DAP Step Over" })
map("n", "<F11>", function() dap.step_into() end, { desc = "DAP Step Into" })
map("n", "<F12>", function() dap.step_out() end, { desc = "DAP Step Out" })
map("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
map("n", "<leader>dr", function() dap.repl.open() end, { desc = "DAP Open REPL" })
map("n", "<leader>dl", function() dap.run_last() end, { desc = "DAP Run Last Debugging Session" })

-- DAP UI (If using nvim-dap-ui)
local dapui = require "dapui"
map("n", "<leader>du", function() dapui.toggle() end, { desc = "DAP UI Toggle" })

-- Markdown Preview Key Mappings (normal mode only; <Plug> mappings)
vim.api.nvim_set_keymap("n", "<C-s>", "<Plug>MarkdownPreview", {})
vim.api.nvim_set_keymap("n", "<M-s>", "<Plug>MarkdownPreviewStop", {})
vim.api.nvim_set_keymap("n", "<C-p>", "<Plug>MarkdownPreviewToggle", {})
