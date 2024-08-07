return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use { 'catppuccin/nvim', as = 'catppuccin' }

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-tree/nvim-web-devicons' },
        }
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },   -- Required
            {                              -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },   -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },   -- Required
        }
    }

    use("windwp/nvim-ts-autotag")
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('gitsigns').setup()
        end
    }

    use {
      'jinh0/eyeliner.nvim',
      config = function()
        require'eyeliner'.setup {
          highlight_on_key = true,
          dim = false
        }
      end
    }

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use('lervag/vimtex')
    use('tpope/vim-fugitive')
    use('tpope/vim-commentary')
    use('wellle/context.vim')
    use('github/copilot.vim')
    use('christoomey/vim-tmux-navigator')
    use('slint-ui/vim-slint')
    use('fatih/vim-go')
end)

