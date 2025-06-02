return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        -- Snippets
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
    },
    config = function()
        local autoformat_filetypes = {
            "lua",
        }
        -- Create a keymap for vim.lsp.buf.implementation
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then return end
                if vim.tbl_contains(autoformat_filetypes, vim.bo.filetype) then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({
                                formatting_options = { tabSize = 4, insertSpaces = true },
                                bufnr = args.buf,
                                id = client.id
                            })
                        end
                    })
                end
            end
        })
        -- Add borders to floating windows
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover,
            { border = 'rounded' }
        )
        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            { border = 'rounded' }
        )

        -- Configure error/warnings interface
        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = {
                style = 'minimal',
                border = 'rounded',
                header = '',
                prefix = '',
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '✘',
                    [vim.diagnostic.severity.WARN] = '▲',
                    [vim.diagnostic.severity.HINT] = '⚑',
                    [vim.diagnostic.severity.INFO] = '»',
                },
            },
        })

        -- Add cmp_nvim_lsp capabilities settings to lspconfig
        -- This should be executed before you configure any language server
        local lspconfig_defaults = require('lspconfig').util.default_config
        lspconfig_defaults.capabilities = vim.tbl_deep_extend(
            'force',
            lspconfig_defaults.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
        )

        -- This is where you enable features that only work
        -- if there is a language server active in the file
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
                local opts = { buffer = event.buf }

                vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
                vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            end,
        })

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {
                "lua_ls",
                "intelephense",
                "ts_ls",
                "eslint",
                "angularls"
            },
            handlers = {
                -- This first function is the "default handler"
                -- it applies to every language server without a custom handler
                angularls = function()
                    require('lspconfig').angularls.setup({
                        cmd = { "ngserver", "--stdio", "--tsProbeLocations", "", "--ngProbeLocations", "" },
                        filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
                        root_dir = require('lspconfig').util.root_pattern('angular.json', 'project.json'),
                        on_new_config = function(new_config, new_root_dir)
                            new_config.cmd = {
                                "ngserver",
                                "--stdio",
                                "--tsProbeLocations", new_root_dir,
                                "--ngProbeLocations", new_root_dir
                            }
                        end,
                    })
                end,

                omnisharp = function()
                    local pid = vim.fn.getpid()
                    local omnisharp_bin = "/home/code_gig/.local/bin/omnisharp-roslyn/OmniSharp"

                    require('lspconfig').omnisharp.setup({
                        cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
                        capabilities = require('cmp_nvim_lsp').default_capabilities(),
                        on_attach = function(client, bufnr)
                            local opts = { buffer = bufnr }

                            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                            vim.keymap.set('n', '<space>wl', function()
                                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                            end, opts)
                            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
                            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                            vim.keymap.set('n', '<space>f', function()
                                vim.lsp.buf.format({ async = true })
                            end, opts)
                        end,
                    })
                end,
                ["ts_ls"] = function()
                    require('lspconfig').ts_ls.setup({
                        filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
                        cmd = { "typescript-language-server", "--stdio" },
                        capabilities = require('cmp_nvim_lsp').default_capabilities(),
                        on_attach = function(client, bufnr)
                            local opts = { buffer = bufnr }
                            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                            -- Format on save
                            if client.server_capabilities.documentFormattingProvider then
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    buffer = bufnr,
                                    callback = function()
                                        vim.lsp.buf.format({ async = true })
                                    end
                                })
                            end
                        end,
                    })
                end,
                function(server_name)
                    require('lspconfig')[server_name].setup({})
                end,

                -- this is the "custom handler" for `lua_ls`
                lua_ls = function()
                    require('lspconfig').lua_ls.setup({
                        settings = {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT',
                                },
                                diagnostics = {
                                    globals = { 'vim' },
                                },
                                workspace = {
                                    library = { vim.env.VIMRUNTIME },
                                },
                            },
                        },
                    })
                end,
            },
        })

        local cmp = require('cmp')

        require('luasnip.loaders.from_vscode').lazy_load()

        vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

        cmp.setup({
            preselect = 'item',
            completion = {
                completeopt = 'menu,menuone,noinsert'
            },
            window = {
                documentation = cmp.config.window.bordered(),
            },
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'buffer',  keyword_length = 3 },
                { name = 'luasnip', keyword_length = 2 },
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            formatting = {
                fields = { 'abbr', 'menu', 'kind' },
                format = function(entry, item)
                    local n = entry.source.name
                    if n == 'nvim_lsp' then
                        item.menu = '[LSP]'
                    else
                        item.menu = string.format('[%s]', n)
                    end
                    return item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                -- confirm completion item
                ['<CR>'] = cmp.mapping.confirm({ select = false }),

                -- scroll documentation window
                ['<C-f>'] = cmp.mapping.scroll_docs(5),
                ['<C-u>'] = cmp.mapping.scroll_docs(-5),

                -- toggle completion menu
                ['<C-e>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.abort()
                    else
                        cmp.complete()
                    end
                end),

                -- tab complete
                ['<Tab>'] = cmp.mapping(function(fallback)
                    local col = vim.fn.col('.') - 1

                    if cmp.visible() then
                        cmp.select_next_item({ behavior = 'select' })
                    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { 'i', 's' }),

                -- go to previous item
                ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),

                -- navigate to next snippet placeholder
                ['<C-d>'] = cmp.mapping(function(fallback)
                    local luasnip = require('luasnip')

                    if luasnip.jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                -- navigate to the previous snippet placeholder
                ['<C-b>'] = cmp.mapping(function(fallback)
                    local luasnip = require('luasnip')

                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            }),
        })
    end
}
