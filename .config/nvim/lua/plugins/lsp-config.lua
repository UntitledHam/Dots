return {
    -- Mason package manager
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    -- Bridge between Mason and Neovim LSP
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    "ruff",
                    "pylsp",
                    "clangd",
                    "bashls",
                    "html",
                    "jdtls",
                    "jinja_lsp",
                },
                handlers = {
                    function(server)
                        local opts = { capabilities = require("cmp_nvim_lsp").default_capabilities() }

                        -- Example of per-server config
                        if server == "pylsp" then
                            opts.settings = {
                                pylsp = {
                                    plugins = {
                                        pycodestyle = { maxLineLength = 200 },
                                        flake8 = { maxLineLength = 200 },
                                    },
                                },
                            }
                        end

                        require("lspconfig")[server].setup(opts)
                    end,
                },
            })
        end,
    },

    -- Core LSP setup
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Automatically start LSPs when entering supported filetypes
            local ft_to_server = {
                lua = "lua_ls",
                typescript = "ts_ls",
                javascript = "ts_ls",
                java = "jdtls",
                c = "clangd",
                cpp = "clangd",
                sh = "bashls",
                html = "html",
                python = "pylsp",
                jinja = "jinja_lsp",
            }

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(event)
                    local server = ft_to_server[event.match]
                    if server and vim.lsp.config[server] then
                        vim.lsp.start(vim.lsp.config[server])
                    end
                end,
            })

            -- Keymaps
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },
}
