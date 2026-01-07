--[[
=====================================================================
==================== NEOVIM CONCISE CONFIGURATION ===================
=====================================================================
A concise, outline-driven configuration.
Chapters:
1. Foundation (Options)
2. Manager (Lazy.nvim)
3. Plugins (UI, Tools, Intelligence, Knowledge)
4. Workflow (Custom Scripts)
]]

-- ==================================================================
-- Chapter 1: The Foundation
-- ==================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Options
vim.o.number = true
vim.o.relativenumber = true -- Line numbers
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true -- Indentation
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end) -- Clipboard
vim.o.ignorecase = true
vim.o.smartcase = true -- Search
-- UI
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.guicursor = "n-v-i-c:block-Cursor"
vim.o.scrolloff = 10 -- 原本我打算讓游標一直待在畫面中間，但這真的太暈了
vim.o.splitright = true
vim.o.splitbelow = true -- Splits
vim.o.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- Whitespace
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.confirm = true
vim.o.inccommand = "split"
vim.o.mouse = "a" -- Behavior

-- Basic Keymaps
vim.keymap.set("n", "!", ":!")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Search Highlights" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

-- ==================================================================
-- Chapter 2: The Manager
-- ==================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ==================================================================
-- Chapter 3: The Plugins
-- ==================================================================
require("lazy").setup({

    -- [[ Section 3.1: UI & Aesthetics ]]
    -- 1. gruvbox-material: Theme (Medium, Performance)
    -- 2. mini.statusline: Simple icons statusline
    -- 3. neo-tree: File Explorer (<leader>e)
    -- 4. which-key: Keymap Helper
    -- 5. image.nvim: Image support (Markdown)

    {
        "sainnhe/gruvbox-material",
        priority = 1000,
        init = function()
            vim.g.gruvbox_material_background = "medium"
            vim.g.gruvbox_material_better_performance = 1
            vim.cmd.colorscheme("gruvbox-material")
        end,
    },
    {
        "echasnovski/mini.statusline",
        config = function()
            require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
        keys = { { "<leader>e", ":Neotree toggle<CR>", desc = "Toggle Explorer" } },
        opts = { filesystem = { window = { mappings = { ["\\"] = "close_window" } } } },
    },
    { "folke/which-key.nvim", event = "VimEnter", opts = { icons = { mappings = vim.g.have_nerd_font } } },
    -- {
    --     "3rd/image.nvim",
    --     build = false,
    --     opts = {
    --         backend = "kitty",
    --         processor = "magick_cli",
    --         integrations = { markdown = { enabled = true, filetypes = { "markdown", "vimwiki" } } },
    --         editor_only_render_when_focused = true,
    --         window_overlap_clear_enabled = true, -- auto show/hide images when the editor gains/looses focus
    --         tmux_show_only_in_active_window = true,
    --     },
    -- },

    -- [[ Section 3.2: The Tools ]]
    -- 1. Neogit: Git Interface (<leader>gg)
    -- 2. gitsigns: Gutter signs
    -- 3. mini.ai/surround: Text objects & surroundings
    -- 4. guess-indent: Auto-detect indentation
    -- 5. Telescope: Fuzzy Finder (<leader>s...)
    -- 6. LuaSnip: Custom Snippets

    {
        "NeogitOrg/neogit",
        dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim" },
        config = true,
        keys = { { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" } },
    },
    { "lewis6991/gitsigns.nvim", opts = {} },
    {
        "echasnovski/mini.nvim",
        config = function()
            require("mini.ai").setup({ n_lines = 500 })
            require("mini.surround").setup()
        end,
    },
    { "NMAC427/guess-indent.nvim", opts = {} },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("telescope").setup({
                extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() } },
            })
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")
            local builtin = require("telescope.builtin")
            -- Map: <leader>s...
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
            vim.keymap.set("n", "<leader>/", function()
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false }))
            end, { desc = "[/] Fuzzily search in current buffer" })
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
    },

    -- [[ Section 3.3: The Intelligence ]]
    -- 1. blink.cmp: Autocompletion (LSP, Snippets, Buffer)
    -- 2. nvim-lspconfig: Language Servers (Mason, Fidget, Lazydev)
    -- 3. conform.nvim: Formatting (Stylua, Black)
    -- 4. Treesitter: Syntax Highlighting

    {
        "saghen/blink.cmp",
        version = "v0.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = {
            keymap = { preset = "default" },
            appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" },
            signature = { enabled = true },
            sources = { default = { "lsp", "path", "snippets", "buffer" } },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "j-hui/fidget.nvim",
            { "folke/lazydev.nvim", ft = "lua", opts = {} },
            "saghen/blink.cmp",
        },
        config = function()
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = { callSnippet = "Replace" },
                            format = { enable = true, default_config = { indent_style = "space", indent_size = "4" } },
                        },
                    },
                },
                marksman = {},
                pyright = {},
                clangd = {},
            }
            local formatters = { "stylua", "isort", "black", "prettier" }
            require("mason").setup()
            require("mason-tool-installer").setup({
                ensure_installed = vim.tbl_flatten({ vim.tbl_keys(servers), formatters }),
            })
            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = require("blink.cmp").get_lsp_capabilities(server.capabilities)
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end
                    -- Inlay Hints: Enable automatically
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
                    end
                    -- Maps
                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                    map(
                        "<leader>ws",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[W]orkspace [S]ymbols"
                    )
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                    map("K", vim.lsp.buf.hover, "Hover Documentation")
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                end,
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        opts = {
            notify_on_error = false,
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
            formatters_by_ft = { lua = { "stylua" }, python = { "isort", "black" }, markdown = { "prettier" } },
            formatters = { stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" } } },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "html",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "python",
                "vim",
                "vimdoc",
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- [[ Section 3.4: Knowledge ]]
    -- 1. render-markdown: Preview Markdown
    -- 2. obsidian.nvim: Note taking (<leader>o...)
    -- 3. otter.nvim: Literate Programming (Code injection)

    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
        opts = { heading = { enabled = false }, code = { enabled = true, width = "block" }, latex = { enabled = true } },
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            workspaces = {
                { name = "ABB00717", path = "~/Documents/ABB00717/" },
                { name = "Obsidian Media", path = "~/Documents/Obsidian Media/" },
            },
            ui = { enable = false },
        },
        keys = {
            { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian New" },
            { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian Search" },
            { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian Template" },
        },
    },
    {
        "jmbuhr/otter.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "markdown",
                callback = function()
                    require("otter").activate({ "python", "bash", "lua" })
                end,
            })
        end,
    },
})

-- ==================================================================
-- Chapter 4: The Custom Workflow
-- ==================================================================
vim.api.nvim_create_user_command("FitToggle", function()
    if _G.FitEnabled then
        _G.FitEnabled = false
        print("Git Sync Disabled")
    else
        _G.FitEnabled = true
        print("Git Sync Enabled")
        local timer = vim.loop.new_timer()
        timer:start(
            0,
            300000,
            vim.schedule_wrap(function()
                if not _G.FitEnabled then
                    timer:close()
                    return
                end
                vim.cmd("silent! !git commit -am 'autosave' && git push")
                print("Git Sync: Pushed")
            end)
        )
    end
end, {})

-- vim: ts=4 sts=4 sw=4 et
