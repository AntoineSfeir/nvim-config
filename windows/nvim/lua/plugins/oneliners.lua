return {
    { -- This helps with ssh tunneling and copying to the clipboard
        'ojroques/vim-oscyank',
    },
    {
        -- Git plugin
        'tpope/vim-fugitive',
    },
    {
        -- Show CSS Colors
        'brenoprata10/nvim-highlight-colors',
        config = function()
            require('nvim-highlight-colors').setup({})
        end
    },
    -- File Explorer
    -- {
    --     "nvim-tree/nvim-tree.lua",
    --     config = function()
    --         require("nvim-tree").setup()
    --     end,
    -- },
    -- Markdown preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
}
