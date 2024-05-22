return {
    -- the colorscheme should be available when starting Neovim
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = true
            })
            vim.cmd([[colorscheme catppuccin-mocha]])
        end,
    },
    -- {
    --   "folke/tokyonight.nvim",
    --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
    --   priority = 1000, -- make sure to load this before all the other start plugins
    --   config = function()
    --     -- load the colorscheme here
    --     vim.cmd([[colorscheme tokyonight]])
    --   end,
    -- },

    -- I have a separate config.mappings file where I require which-key.
    -- With lazy the plugin will be automatically loaded when it is required somewhere
    {
        "folke/which-key.nvim",
        lazy = true
    },

    {
        "nvim-neorg/neorg",
        -- lazy-load on filetype
        ft = "norg",
        -- options for neorg. This will automatically call `require("neorg").setup(opts)`
        opts = {
            load = {
                ["core.defaults"] = {},
            },
        },
    },

    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        -- init is called during startup. Configuration for vim plugins typically should be set in an init function
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },

    -- if some code requires a module from an unloaded plugin, it will be automatically loaded.
    -- So for api plugins like devicons, we can always set lazy=true
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- you can use the VeryLazy event for things that can
    -- load later and are not important for the initial UI
    { "stevearc/dressing.nvim",      event = "VeryLazy" },

    {
        "Wansmer/treesj",
        keys = {
            { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
        },
        opts = { use_default_keymaps = false, max_join_length = 150 },
    },

    {
        "monaqa/dial.nvim",
        -- lazy-load on keys
        -- mode is `n` by default. For more advanced options, check the section on key mappings
        keys = { "<C-a>", { "<C-x>", mode = "n" } },
    },

    -- local plugins need to be explicitly configured with dir
    { dir = "~/projects/secret.nvim" },

    -- you can use a custom url to fetch a plugin
    { url = "git@github.com:folke/noice.nvim.git" },
    -- local plugins can also be configure with the dev option.
    -- This will use {config.dev.path}/noice.nvim/ instead of fetching it from Github
    -- With the dev option, you can easily switch between the local and installed version of a plugin
    { "folke/noice.nvim",                         dev = true },

    -- Code Editing
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },
    { "VonHeikemen/lsp-zero.nvim" },
    { "mbbill/undotree" },
    { "onsails/lspkind.nvim" },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup()
        end
    },
    {
        "neovim/nvim-lspconfig",
    },

    {
        "hrsh7th/nvim-cmp",
        -- load cmp on InsertEnter
        event = "InsertEnter",
        -- these dependencies will only be loaded when cmp loads
        -- dependencies are always lazy-loaded unless specified otherwise
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
        },
        opts = function()
            local cmp_status, cmp = pcall(require, "cmp")
            local lspkind = require('lspkind')
            if not cmp_status then
                print(cmp_status)
                return
            end

            return {
                cmp.setup({
                    mapping = cmp.mapping.preset.insert({
                        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                        ["<C-e>"] = cmp.mapping.abort(),        -- close completion window
                        ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    }),
                    -- sources for autocompletion
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" }, -- LSP
                        { name = "buffer" },   -- text within the current buffer
                        { name = "path" },     -- file system paths
                    }),
                }),

                -- Set configuration for specific filetype.
                cmp.setup.filetype('gitcommit', {
                    sources = cmp.config.sources({
                        { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
                    }, {
                        { name = 'buffer' },
                    })
                }),

                -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
                cmp.setup.cmdline({ '/', '?' }, {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        { name = "nvim_lsp" },
                        { name = 'buffer' },
                        { name = 'path' },
                    }
                }),

                -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
                cmp.setup.cmdline(':', {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources({
                        { name = 'path' }
                    }, {
                        { name = 'cmdline' }
                    }),
                    matching = { disallow_symbol_nonprefix_matching = false }
                }),

                cmp.setup {
                    formatting = {
                        format = lspkind.cmp_format({
                            mode = 'symbol_text',  -- show only symbol annotations
                            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                            preset = 'default',
                            symbol_map = {
                                Text = "󰉿",
                                Method = "󰆧",
                                Function = "󰊕",
                                Constructor = "",
                                Field = "󰜢",
                                Variable = "󰀫",
                                Class = "󰠱",
                                Interface = "",
                                Module = "",
                                Property = "󰜢",
                                Unit = "󰑭",
                                Value = "󰎠",
                                Enum = "",
                                Keyword = "󰌋",
                                Snippet = "",
                                Color = "󰏘",
                                File = "󰈙",
                                Reference = "󰈇",
                                Folder = "󰉋",
                                EnumMember = "",
                                Constant = "󰏿",
                                Struct = "󰙅",
                                Event = "",
                                Operator = "󰆕",
                                TypeParameter = "",
                            },

                            -- The function below will be called before any actual modifications from lspkind
                            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                        })
                    }
                }
            }
        end,
    },
    -- Debugging and Debugger
    { "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui" },
    { "theHamsta/nvim-dap-virtual-text" },

    -- Dev Containers
    {
        'https://codeberg.org/esensar/nvim-dev-container',
        dependencies = 'nvim-treesitter/nvim-treesitter',
    },

    -- Ricing
    { 'nanozuki/tabby.nvim' },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require("devcontainer").setup {
                attach_mounts = {
                    neovim_config = {
                        -- enables mounting local config to /root/.config/nvim in container
                        enabled = false,
                        -- makes mount readonly in container
                        options = { "readonly" }
                    },
                    neovim_data = {
                        -- enables mounting local data to /root/.local/share/nvim in container
                        enabled = false,
                        -- no options by default
                        options = {}
                    },
                    -- Only useful if using neovim 0.8.0+
                    neovim_state = {
                        -- enables mounting local state to /root/.local/state/nvim in container
                        enabled = false,
                        -- no options by default
                        options = {}
                    },
                },
            }
        end
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        config = function()
            -- Unless you are still migrating, remove the deprecated commands from v1.x
            vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

            -- If you want icons for diagnostic errors, you'll need to define them somewhere:
            vim.fn.sign_define("DiagnosticSignError",
                { text = " ", texthl = "DiagnosticSignError" })
            vim.fn.sign_define("DiagnosticSignWarn",
                { text = " ", texthl = "DiagnosticSignWarn" })
            vim.fn.sign_define("DiagnosticSignInfo",
                { text = " ", texthl = "DiagnosticSignInfo" })
            vim.fn.sign_define("DiagnosticSignHint",
                { text = "", texthl = "DiagnosticSignHint" })
            -- NOTE: this is changed from v1.x, which used the old style of highlight groups
            -- in the form "LspDiagnosticsSignWarning"

            require("neo-tree").setup({
                close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
                popup_border_style = "rounded",
                enable_git_status = true,
                enable_diagnostics = true,
                open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
                sort_case_insensitive = false,                                     -- used when sorting files and directories in the tree
                sort_function = nil,                                               -- use a custom function for sorting files and directories in the tree
                -- sort_function = function (a,b)
                --       if a.type == b.type then
                --           return a.path > b.path
                --       else
                --           return a.type > b.type
                --       end
                --   end , -- this sorts files and directories descendantly
                default_component_configs = {
                    container = {
                        enable_character_fade = true
                    },
                    indent = {
                        indent_size = 2,
                        padding = 1, -- extra padding on left hand side
                        -- indent guides
                        with_markers = true,
                        indent_marker = "│",
                        last_indent_marker = "└",
                        highlight = "NeoTreeIndentMarker",
                        -- expander config, needed for nesting files
                        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                        expander_collapsed = "",
                        expander_expanded = "",
                        expander_highlight = "NeoTreeExpander",
                    },
                    icon = {
                        folder_closed = "",
                        folder_open = "",
                        folder_empty = "ﰊ",
                        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                        -- then these will never be used.
                        default = "*",
                        highlight = "NeoTreeFileIcon"
                    },
                    modified = {
                        symbol = "[+]",
                        highlight = "NeoTreeModified",
                    },
                    name = {
                        trailing_slash = false,
                        use_git_status_colors = true,
                        highlight = "NeoTreeFileName",
                    },
                    git_status = {
                        symbols = {
                            -- Change type
                            added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                            modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                            deleted   = "✖", -- this can only be used in the git_status source
                            renamed   = "", -- this can only be used in the git_status source
                            -- Status type
                            untracked = "",
                            ignored   = "",
                            unstaged  = "",
                            staged    = "",
                            conflict  = "",
                        }
                    },
                },
                window = {
                    position = "left",
                    width = 40,
                    mapping_options = {
                        noremap = true,
                        nowait = true,
                    },
                    mappings = {
                        ["<space>"] = {
                            "toggle_node",
                            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
                        },
                        ["<2-LeftMouse>"] = "open",
                        ["<cr>"] = "open",
                        ["<esc>"] = "revert_preview",
                        ["P"] = { "toggle_preview", config = { use_float = true } },
                        ["l"] = "focus_preview",
                        ["S"] = "open_split",
                        ["s"] = "open_vsplit",
                        -- ["S"] = "split_with_window_picker",
                        -- ["s"] = "vsplit_with_window_picker",
                        ["t"] = "open_tabnew",
                        -- ["<cr>"] = "open_drop",
                        -- ["t"] = "open_tab_drop",
                        ["w"] = "open_with_window_picker",
                        --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
                        ["C"] = "close_node",
                        -- ['C'] = 'close_all_subnodes',
                        ["z"] = "close_all_nodes",
                        --["Z"] = "expand_all_nodes",
                        ["a"] = {
                            "add",
                            -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
                            -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                            config = {
                                show_path = "none" -- "none", "relative", "absolute"
                            }
                        },
                        ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
                        ["d"] = "delete",
                        ["r"] = "rename",
                        ["y"] = "copy_to_clipboard",
                        ["x"] = "cut_to_clipboard",
                        ["p"] = "paste_from_clipboard",
                        ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
                        -- ["c"] = {
                        --  "copy",
                        --  config = {
                        --    show_path = "none" -- "none", "relative", "absolute"
                        --  }
                        --}
                        ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
                        ["q"] = "close_window",
                        ["R"] = "refresh",
                        ["?"] = "show_help",
                        ["<"] = "prev_source",
                        [">"] = "next_source",
                    }
                },
                nesting_rules = {},
                filesystem = {
                    filtered_items = {
                        visible = false, -- when true, they will just be displayed differently than normal items
                        hide_dotfiles = true,
                        hide_gitignored = true,
                        hide_hidden = true, -- only works on Windows for hidden files/directories
                        hide_by_name = {
                            --"node_modules"
                        },
                        hide_by_pattern = { -- uses glob style patterns
                            --"*.meta",
                            --"*/src/*/tsconfig.json",
                        },
                        always_show = { -- remains visible even if other settings would normally hide it
                            --".gitignored",
                        },
                        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                            --".DS_Store",
                            --"thumbs.db"
                        },
                        never_show_by_pattern = { -- uses glob style patterns
                            --".null-ls_*",
                        },
                    },
                    follow_current_file = false,            -- This will find and focus the file in the active buffer every
                    -- time the current file is changed while the tree is open.
                    group_empty_dirs = false,               -- when true, empty folders will be grouped together
                    hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                    -- in whatever position is specified in window.position
                    -- "open_current",  -- netrw disabled, opening a directory opens within the
                    -- window like netrw would, regardless of window.position
                    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
                    use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                    -- instead of relying on nvim autocmd events.
                    window = {
                        mappings = {
                            ["<bs>"] = "navigate_up",
                            ["."] = "set_root",
                            ["H"] = "toggle_hidden",
                            ["/"] = "fuzzy_finder",
                            ["D"] = "fuzzy_finder_directory",
                            ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
                            -- ["D"] = "fuzzy_sorter_directory",
                            ["f"] = "filter_on_submit",
                            ["<c-x>"] = "clear_filter",
                            ["[g"] = "prev_git_modified",
                            ["]g"] = "next_git_modified",
                        }
                    }
                },
                buffers = {
                    follow_current_file = true, -- This will find and focus the file in the active buffer every
                    -- time the current file is changed while the tree is open.
                    group_empty_dirs = true,    -- when true, empty folders will be grouped together
                    show_unloaded = true,
                    window = {
                        mappings = {
                            ["bd"] = "buffer_delete",
                            ["<bs>"] = "navigate_up",
                            ["."] = "set_root",
                        }
                    },
                },
                git_status = {
                    window = {
                        position = "float",
                        mappings = {
                            ["A"]  = "git_add_all",
                            ["gu"] = "git_unstage_file",
                            ["ga"] = "git_add_file",
                            ["gr"] = "git_revert_file",
                            ["gc"] = "git_commit",
                            ["gp"] = "git_push",
                            ["gg"] = "git_commit_and_push",
                        }
                    }
                }
            })

            vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
        end
    },
    { 'theprimeagen/harpoon' },
    { 'mbbill/undotree' },
    { 'tpope/vim-fugitive' },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 'MaximilianLloyd/ascii.nvim', dependencies = { 'MunifTanjim/nui.nvim' } },
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    }
}

--    -- Packer can manage itself
--     use 'wbthomason/packer.nvim'

--     -- use { 'jiangmiao/auto-pairs' }
--     use {
--         "windwp/nvim-autopairs",
--         config = function() require("nvim-autopairs").setup {} end
--     }

--     use { 'nvim-tree/nvim-web-devicons' }

--     use { 'shaunsingh/solarized.nvim' }

--     -- Debugging
--     use { "mfussenegger/nvim-dap" }
--     use { "rcarriga/nvim-dap-ui" }
--     use { "theHamsta/nvim-dap-virtual-text" }

--     -- WhichKey
--     use {
--         "folke/which-key.nvim",
--         config = function()
--             vim.o.timeout = true
--             vim.o.timeoutlen = 300
--             require("which-key").setup {
--                 -- your configuration comes here
--                 -- or leave it empty to use the default settings
--                 -- refer to the configuration section below
--             }
--         end
--     }

--     -- Dev Containers
--     use { 'https://codeberg.org/esensar/nvim-dev-container',
--         config = require("devcontainer").setup{}
--     }

--     -- NeoTest
--     use {
--       "nvim-neotest/neotest",
--       requires = {
--         "nvim-neotest/nvim-nio",
--         "nvim-lua/plenary.nvim",
--         "antoinemadec/FixCursorHold.nvim",
--         "nvim-treesitter/nvim-treesitter"
--       }
--     }

--     use { "EdenEast/nightfox.nvim" }

--     use({
--         "iamcco/markdown-preview.nvim",
--         run = "cd app && npm install",
--         setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
--         ft = { "markdown" },
--     })

--     use { 'nanozuki/tabby.nvim' }

--     use { 'theHamsta/nvim-dap-virtual-text' }

--     use {
--         'nvim-lualine/lualine.nvim',
--         requires = { 'nvim-tree/nvim-web-devicons', opt = true }
--     }

--     use {
--         "felipeagc/fleet-theme-nvim",
--         dependencies = { "rktjmp/lush.nvim" }, -- lush.nvim is required
--     }

--     use { 'nyoom-engineering/oxocarbon.nvim' }

--     use { "rktjmp/lush.nvim" }

--     use { "onsails/lspkind-nvim" }

--     use { 'Mofiqul/vscode.nvim' }

--     use { 'lervag/vimtex' }

--     use { "mrjones2014/nvim-ts-rainbow", config =
--         function()
--             require("nvim-treesitter.configs").setup {
--                 highlight = {
--                     -- ...
--                 },
--                 -- ...
--                 rainbow = {
--                     enable = true,
--                     -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
--                     extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
--                     max_file_lines = nil, -- Do not enable for files with more than n lines, int
--                     -- colors = {}, -- table of hex strings
--                     -- termcolors = {} -- table of colour name strings
--                 },
--             }
--         end }

--     use { "folke/zen-mode.nvim" }

--     use { "lukas-reineke/indent-blankline.nvim" }

--     use {
--         'nvim-lualine/lualine.nvim',
--         requires = { 'kyazdani42/nvim-web-devicons', opt = true }
--     }

--     -- Friendship with Tabnine over Copilot is by best friend now
--     -- use { 'codota/tabnine-nvim', run = "./dl_binaries.sh" }
--     use { 'github/copilot.vim' }

--     use {
--         'nvim-telescope/telescope.nvim', tag = '0.1.4',
--         -- or                            , branch = '0.1.x',
--         requires = { { 'nvim-lua/plenary.nvim' } }
--     }

--     use({
--         "rebelot/kanagawa.nvim",
--         as     = 'kanagawa',
--         config = function()
--             vim.cmd("colorscheme kanagawa-dragon")
--         end
--     })

--     use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

--     use('nvim-treesitter/playground')

--     use('theprimeagen/harpoon')

--     use('mbbill/undotree')

--     use('tpope/vim-fugitive')

--     use {
--         'VonHeikemen/lsp-zero.nvim',
--         branch = 'v1.x',
--         requires = {
--             -- LSP Support
--             { 'neovim/nvim-lspconfig' },             -- Required
--             { 'williamboman/mason.nvim' },           -- Optional
--             { 'williamboman/mason-lspconfig.nvim' }, -- Optional

--             -- Autocompletion
--             { 'hrsh7th/nvim-cmp' },         -- Required
--             { 'hrsh7th/cmp-nvim-lsp' },     -- Required
--             { 'hrsh7th/cmp-buffer' },       -- Optional
--             { 'hrsh7th/cmp-path' },         -- Optional
--             { 'saadparwaiz1/cmp_luasnip' }, -- Optional
--             { 'hrsh7th/cmp-nvim-lua' },     -- Optional

--             -- Snippets
--             { 'L3MON4D3/LuaSnip' },             -- Required
--             { 'rafamadriz/friendly-snippets' }, -- Optional
--         }
--     }

--     use {
--         "nvim-neo-tree/neo-tree.nvim",
--         branch = "v2.x",
--         requires = {
--             "nvim-lua/plenary.nvim",
--             "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
--             "MunifTanjim/nui.nvim",
--             {
--                 -- only needed if you want to use the commands with "_with_window_picker" suffix
--                 's1n7ax/nvim-window-picker',
--                 tag = "v1.*",
--                 config = function()
--                     require 'window-picker'.setup({
--                         autoselect_one = true,
--                         include_current = false,
--                         filter_rules = {
--                             -- filter using buffer options
--                             bo = {
--                                 -- if the file type is one of following, the window will be ignored
--                                 filetype = { 'neo-tree', "neo-tree-popup", "notify" },
--                                 -- if the buffer type is one of following, the window will be ignored
--                                 buftype = { 'terminal', "quickfix" },
--                             },
--                         },
--                         other_win_hl_color = '#e35e4f',
--                     })
--                 end,
--             }
--         },
--         config = function()
--             -- Unless you are still migrating, remove the deprecated commands from v1.x
--             vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

--             -- If you want icons for diagnostic errors, you'll need to define them somewhere:
--             vim.fn.sign_define("DiagnosticSignError",
--                 { text = " ", texthl = "DiagnosticSignError" })
--             vim.fn.sign_define("DiagnosticSignWarn",
--                 { text = " ", texthl = "DiagnosticSignWarn" })
--             vim.fn.sign_define("DiagnosticSignInfo",
--                 { text = " ", texthl = "DiagnosticSignInfo" })
--             vim.fn.sign_define("DiagnosticSignHint",
--                 { text = "", texthl = "DiagnosticSignHint" })
--             -- NOTE: this is changed from v1.x, which used the old style of highlight groups
--             -- in the form "LspDiagnosticsSignWarning"

--             require("neo-tree").setup({
--                 close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
--                 popup_border_style = "rounded",
--                 enable_git_status = true,
--                 enable_diagnostics = true,
--                 open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
--                 sort_case_insensitive = false,                                     -- used when sorting files and directories in the tree
--                 sort_function = nil,                                               -- use a custom function for sorting files and directories in the tree
--                 -- sort_function = function (a,b)
--                 --       if a.type == b.type then
--                 --           return a.path > b.path
--                 --       else
--                 --           return a.type > b.type
--                 --       end
--                 --   end , -- this sorts files and directories descendantly
--                 default_component_configs = {
--                     container = {
--                         enable_character_fade = true
--                     },
--                     indent = {
--                         indent_size = 2,
--                         padding = 1, -- extra padding on left hand side
--                         -- indent guides
--                         with_markers = true,
--                         indent_marker = "│",
--                         last_indent_marker = "└",
--                         highlight = "NeoTreeIndentMarker",
--                         -- expander config, needed for nesting files
--                         with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
--                         expander_collapsed = "",
--                         expander_expanded = "",
--                         expander_highlight = "NeoTreeExpander",
--                     },
--                     icon = {
--                         folder_closed = "",
--                         folder_open = "",
--                         folder_empty = "ﰊ",
--                         -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
--                         -- then these will never be used.
--                         default = "*",
--                         highlight = "NeoTreeFileIcon"
--                     },
--                     modified = {
--                         symbol = "[+]",
--                         highlight = "NeoTreeModified",
--                     },
--                     name = {
--                         trailing_slash = false,
--                         use_git_status_colors = true,
--                         highlight = "NeoTreeFileName",
--                     },
--                     git_status = {
--                         symbols = {
--                             -- Change type
--                             added     = "",  -- or "✚", but this is redundant info if you use git_status_colors on the name
--                             modified  = "",  -- or "", but this is redundant info if you use git_status_colors on the name
--                             deleted   = "✖", -- this can only be used in the git_status source
--                             renamed   = "", -- this can only be used in the git_status source
--                             -- Status type
--                             untracked = "",
--                             ignored   = "",
--                             unstaged  = "",
--                             staged    = "",
--                             conflict  = "",
--                         }
--                     },
--                 },
--                 window = {
--                     position = "left",
--                     width = 40,
--                     mapping_options = {
--                         noremap = true,
--                         nowait = true,
--                     },
--                     mappings = {
--                         ["<space>"] = {
--                             "toggle_node",
--                             nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
--                         },
--                         ["<2-LeftMouse>"] = "open",
--                         ["<cr>"] = "open",
--                         ["<esc>"] = "revert_preview",
--                         ["P"] = { "toggle_preview", config = { use_float = true } },
--                         ["l"] = "focus_preview",
--                         ["S"] = "open_split",
--                         ["s"] = "open_vsplit",
--                         -- ["S"] = "split_with_window_picker",
--                         -- ["s"] = "vsplit_with_window_picker",
--                         ["t"] = "open_tabnew",
--                         -- ["<cr>"] = "open_drop",
--                         -- ["t"] = "open_tab_drop",
--                         ["w"] = "open_with_window_picker",
--                         --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
--                         ["C"] = "close_node",
--                         -- ['C'] = 'close_all_subnodes',
--                         ["z"] = "close_all_nodes",
--                         --["Z"] = "expand_all_nodes",
--                         ["a"] = {
--                             "add",
--                             -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
--                             -- some commands may take optional config options, see `:h neo-tree-mappings` for details
--                             config = {
--                                 show_path = "none" -- "none", "relative", "absolute"
--                             }
--                         },
--                         ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
--                         ["d"] = "delete",
--                         ["r"] = "rename",
--                         ["y"] = "copy_to_clipboard",
--                         ["x"] = "cut_to_clipboard",
--                         ["p"] = "paste_from_clipboard",
--                         ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
--                         -- ["c"] = {
--                         --  "copy",
--                         --  config = {
--                         --    show_path = "none" -- "none", "relative", "absolute"
--                         --  }
--                         --}
--                         ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
--                         ["q"] = "close_window",
--                         ["R"] = "refresh",
--                         ["?"] = "show_help",
--                         ["<"] = "prev_source",
--                         [">"] = "next_source",
--                     }
--                 },
--                 nesting_rules = {},
--                 filesystem = {
--                     filtered_items = {
--                         visible = false, -- when true, they will just be displayed differently than normal items
--                         hide_dotfiles = true,
--                         hide_gitignored = true,
--                         hide_hidden = true, -- only works on Windows for hidden files/directories
--                         hide_by_name = {
--                             --"node_modules"
--                         },
--                         hide_by_pattern = { -- uses glob style patterns
--                             --"*.meta",
--                             --"*/src/*/tsconfig.json",
--                         },
--                         always_show = { -- remains visible even if other settings would normally hide it
--                             --".gitignored",
--                         },
--                         never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
--                             --".DS_Store",
--                             --"thumbs.db"
--                         },
--                         never_show_by_pattern = { -- uses glob style patterns
--                             --".null-ls_*",
--                         },
--                     },
--                     follow_current_file = false,            -- This will find and focus the file in the active buffer every
--                     -- time the current file is changed while the tree is open.
--                     group_empty_dirs = false,               -- when true, empty folders will be grouped together
--                     hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
--                     -- in whatever position is specified in window.position
--                     -- "open_current",  -- netrw disabled, opening a directory opens within the
--                     -- window like netrw would, regardless of window.position
--                     -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
--                     use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
--                     -- instead of relying on nvim autocmd events.
--                     window = {
--                         mappings = {
--                             ["<bs>"] = "navigate_up",
--                             ["."] = "set_root",
--                             ["H"] = "toggle_hidden",
--                             ["/"] = "fuzzy_finder",
--                             ["D"] = "fuzzy_finder_directory",
--                             ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
--                             -- ["D"] = "fuzzy_sorter_directory",
--                             ["f"] = "filter_on_submit",
--                             ["<c-x>"] = "clear_filter",
--                             ["[g"] = "prev_git_modified",
--                             ["]g"] = "next_git_modified",
--                         }
--                     }
--                 },
--                 buffers = {
--                     follow_current_file = true, -- This will find and focus the file in the active buffer every
--                     -- time the current file is changed while the tree is open.
--                     group_empty_dirs = true,    -- when true, empty folders will be grouped together
--                     show_unloaded = true,
--                     window = {
--                         mappings = {
--                             ["bd"] = "buffer_delete",
--                             ["<bs>"] = "navigate_up",
--                             ["."] = "set_root",
--                         }
--                     },
--                 },
--                 git_status = {
--                     window = {
--                         position = "float",
--                         mappings = {
--                             ["A"]  = "git_add_all",
--                             ["gu"] = "git_unstage_file",
--                             ["ga"] = "git_add_file",
--                             ["gr"] = "git_revert_file",
--                             ["gc"] = "git_commit",
--                             ["gp"] = "git_push",
--                             ["gg"] = "git_commit_and_push",
--                         }
--                     }
--                 }
--             })

--             vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
--         end
--     }
