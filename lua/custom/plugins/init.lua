-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

vim.keymap.set('n', '<leader>fm', function()
  require('conform').format()
end, { desc = 'format the current buffer' })

vim.keymap.set('n', '<leader>k', function()
  vim.lsp.buf.signature_help()
end, { desc = 'show function signature' })

vim.keymap.set({ 'n', 'i' }, '<C-c>', function()
  -- If we find a floating window, close it.
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, true)
    end
  end
end, { desc = 'close all floating windows' })

vim.keymap.set('v', '>', '>gv', { desc = 'indent selected block' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'move block down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'move block up' })

-- thank u nvchad
vim.keymap.set('x', 'p', 'p:let @+=@0<CR>:let @"=@0<CR>')

vim.opt.smartindent = true
vim.opt.clipboard = 'unnamedplus'

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('trim_whitespaces', { clear = true }),
  desc = 'Trim trailing white spaces',
  pattern = '*',
  callback = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '<buffer>',
      -- Trim trailing whitespaces
      callback = function()
        -- Save cursor position to restore later
        local curpos = vim.api.nvim_win_get_cursor(0)
        -- Search and replace trailing whitespaces
        vim.cmd [[keeppatterns %s/\s\+$//e]]
        vim.api.nvim_win_set_cursor(0, curpos)
      end,
    })
  end,
})

vim.api.nvim_create_user_command('DiagnosticToggle', function()
  local config = vim.diagnostic.config
  local vt = config().virtual_text
  config {
    virtual_text = not vt,
    underline = not vt,
    signs = not vt,
  }
end, { desc = 'toggle diagnostic' })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('trim_whitespaces', { clear = true }),
  desc = 'Trim trailing white spaces',
  pattern = '*',
  callback = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '<buffer>',
      -- Trim trailing whitespaces
      callback = function()
        -- Save cursor position to restore later
        local curpos = vim.api.nvim_win_get_cursor(0)
        -- Search and replace trailing whitespaces
        vim.cmd [[keeppatterns %s/\s\+$//e]]
        vim.api.nvim_win_set_cursor(0, curpos)
      end,
    })
  end,
})

return {
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        default_file_explorer = true,
        -- Id is automatically added at the beginning, and name at the end
        -- See :help oil-columns
        columns = {
          'icon',
          'permissions',
          'size',
          'mtime',
        },
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
          ['<C-h>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
          ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = 'actions.close',
          ['<C-l>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory' },
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['g.'] = 'actions.toggle_hidden',
          ['g\\'] = 'actions.toggle_trash',
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = false,
      }
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<A-f>]],
        direction = 'float',
        close_on_exit = false,
        float_opts = {
          width = 170,
          height = 40,
        },
      }
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  {
    'smoka7/hop.nvim',
    config = function()
      require('hop').setup { keys = 'etovxqpdygfblzhckisura' }
      vim.keymap.set('n', 'm', ':HopWordMW<CR>', { desc = 'hop to any word in the current buffer' })
    end,
    lazy = false,
  },
  {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        log_level = 'error',
      }
    end,
    lazy = false,
  },
  {
    'laytan/cloak.nvim',
    opts = {
      enabled = true,
      cloak_character = '*',
      highlight_group = 'Comment',
      patterns = {
        {
          file_pattern = {
            '.env*',
            'wrangler.toml',
            '.dev.vars',
          },
          cloak_pattern = '=.+',
        },
      },
    },
  },
  {
    'olexsmir/gopher.nvim',
    ft = 'go',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('gopher').setup {
        gotag = {
          transform = 'snakecase',
        },
      }
      vim.keymap.set('n', '<leader>ie', ':GoIfErr<CR>', { desc = 'insert go error handling block' })
    end,
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    opts = {},
  },
  {
    'max397574/better-escape.nvim',
    event = 'InsertEnter',
    config = function()
      require('better_escape').setup()
    end,
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      icons = false,
    },
    config = function()
      vim.keymap.set('n', '<leader>xx', ':TroubleToggle<CR>', { desc = 'show all errors' })
      function EnableLineWrapForTrouble()
        -- Check if the current buffer's file type is "Trouble"
        if vim.bo.filetype == 'Trouble' then
          -- Enable line wrap
          vim.wo.wrap = true
        else
          -- Disable line wrap
          vim.wo.wrap = false
        end
      end

      -- Set up an autocmd to trigger the function when a buffer is loaded
      vim.cmd [[
      augroup LineWrapForTrouble
          autocmd!
          autocmd BufEnter * lua EnableLineWrapForTrouble()
      augroup END
      ]]
    end,
    lazy = false,
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      vim.opt.termguicolors = true
      require('bufferline').setup {
        highlights = {
          diagnostic_selected = { bold = true },
          info_selected = { bold = true },
          info_diagnostic_selected = { bold = true },
          warning_selected = { bold = true },
          warning_diagnostic_selected = { bold = true },
          error_selected = { bold = true },
          error_diagnostic_selected = { bold = true },
          fill = {
            bg = '#282828',
          },
          background = {
            bg = '#3c3836',
            fg = '#fbf1c7',
          },
          close_button = {
            fg = '#fb4934',
            bg = '#3c3836',
          },
          close_button_selected = {
            fg = '#cc241d',
            bg = '#7c6f64',
          },
          separator = {
            bold = true,
            fg = '#3c3836',
            bg = '#3c3836',
          },
          indicator_selected = {
            bold = true,
            fg = '#3c3836',
            bg = '#7c6f64',
          },
          duplicate = {
            italic = true,
            fg = '#fbf1c7',
            bg = '#3c3836',
          },
          duplicate_selected = {
            italic = true,
            fg = '#fbf1c7',
            bg = '#7c6f64',
          },
          buffer_selected = {
            italic = true,
            fg = '#fbf1c7',
            bg = '#7c6f64',
          },
          modified = {
            fg = '#fabd2f',
            bg = '#3c3836',
          },
          modified_visible = {
            fg = '#fabd2f',
            bg = '#3c3836',
          },
          modified_selected = {
            fg = '#fabd2f',
            bg = '#3c3836',
          },
          trunc_marker = {
            bg = '#3c3836',
            fg = '#3c3836',
          },
        },
        options = {
          diagnostics_indicator = function(count, level, _, _)
            local icon = level:match 'error' and ' ' or ' '
            return ' ' .. icon .. count
          end,
        },
      }
      vim.keymap.set('n', '<Tab>', '<CMD>BufferLineCycleNext<CR>')
      vim.keymap.set('n', '<S-Tab>', '<CMD>BufferLineCyclePrev<CR>')
    end,
  },
  {
    'someone-stole-my-name/yaml-companion.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('telescope').load_extension 'yaml_schema'
      require('lspconfig')['yamlls'].setup(require('yaml-companion').setup {})
      vim.keymap.set('n', '<leader>ts', '<CMD>Telescope yaml_schema<CR>', { desc = '[t]elescope yaml [s]chema picker' })
      vim.keymap.set('n', '<leader>DD', function()
        vim.diagnostic.enable(false)
      end, { desc = '[D]isable diagnostics' })
    end,
  },
}
