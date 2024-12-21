-- Use :help <phrase> or "<Space>sh" to search for documentiaton on the <phrase>.
-- For example, `:h mapleader` for the first config set below.
-- Use <Space> as leader key
-- A leader key is used to map customized non-standard actions
vim.g.mapleader = ' '



-- [[ Setting options ]] --
-- More colors. True color support.
vim.opt.termguicolors = true

-- Don't show the mode, since it's already in the status line
-- A status line theme is installed below
vim.opt.showmode = false

-- Enable line number and relative number to help with jumping
vim.opt.number = true
vim.opt.relativenumber = true

-- Highlight the current line to make it stand out visually
vim.opt.cursorline = true

-- Case-insensitive searching UNLESS \C or, one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 300
-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Disable line wrapping
-- If wrap is enabled, then consider enabling breakindent too.
-- `breakindent` maintains indent when wrapping lines. See `:h breakindent`.
vim.opt.wrap = false
vim.opt.breakindent = false

-- Make cursor to always stay on same column when moving to shorter line
vim.opt.virtualedit = 'all'

-- Display whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Save undo history to enable undo even after reopen file
vim.opt.undofile = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 5

-- Minimal number of screen columns to keep left and right the cursor
vim.opt.sidescrolloff = 5

-- Enable more "natural" autocompletion in :e
vim.opt.wildmode = 'longest:full,full'



-- [[ Autocommands ]] --
-- Autocommands are commands executed when an event like 'TermOpen' below triggered.
-- ':h events' for a list of all events

-- Create a group to control behaviours of these autocommands easily
-- In this case, setting `clear = true` clears the outdated ones when reconfiguring new autocommands.
local justed_augroup = vim.api.nvim_create_augroup('justed-defaults', { clear = true })

-- Straight into terminal mode to type commands when run :terminal
-- Also disable some sensible options by default, the autocommand is pretty self-explanatory.
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Set diff defaults on opening a terminal',
  group = justed_augroup,
  -- Match against normal terminal buffers only
  pattern = 'term://*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd.startinsert()
  end,
})

-- Straight into terminal mode when switching window or buffer to a :terminal window
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  -- Match against normal terminal buffers only
  pattern = 'term://*',
  desc = 'Set defaults when switching to a terminal window',
  group = justed_augroup,
  callback = function()
    if vim.o.buftype == 'terminal' then
      vim.cmd.startinsert()
    end
  end,
})

vim.api.nvim_create_autocmd({ 'WinEnter', 'WinLeave' }, {
  pattern = '*',
  desc = 'Turn on and off cursorline for ease of focus',
  group = justed_augroup,
  callback = function(self)
    if self.event == 'WinEnter' then
      vim.opt.cursorline = true
    else
      vim.opt.cursorline = false
    end
  end,
})



-- [[ Keymaps ]] --
-- Use a more "common sense" way to exit terminal mode in :terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Easier window navigation movements
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-Q>', '<C-W><C-Q>', { desc = 'Close window' })
vim.keymap.set('t', '<C-H>', '<C-\\><C-N><C-W><C-H>', { desc = 'Move focus to the left window from terminal mode' })
vim.keymap.set('t', '<C-L>', '<C-\\><C-N><C-W><C-L>', { desc = 'Move focus to the right window from terminal mode' })
vim.keymap.set('t', '<C-J>', '<C-\\><C-N><C-W><C-J>', { desc = 'Move focus to the lower window from terminal mode' })
vim.keymap.set('t', '<C-K>', '<C-\\><C-N><C-W><C-K>', { desc = 'Move focus to the upper window from terminal mode' })
vim.keymap.set('t', '<C-Q>', '<C-\\><C-N><C-W><C-Q>', { desc = 'Close terminal window from terminal mode' })

-- Move a line up and down with KJ in visual mode, while respecting indentations.
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")

-- Use <Esc> to disable highlight on words after search
vim.keymap.set('n', '<Esc>', vim.cmd.nohls)

-- Jump to searched term will always center to screen
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Allow cursor to stay after yanking (copying) in visual mode, not jumping to first character
-- Reference: http://ddrscott.github.io/blog/2016/yank-without-jank/
vim.keymap.set('v', 'y', function() return 'my"' .. vim.v.register .. 'y`y' end, { expr = true, noremap = true })
vim.keymap.set('v', 'Y', function() return 'my"' .. vim.v.register .. 'Y`y' end, { expr = true, noremap = true })



-- [[ Install `mini.deps` plugin manager ]] --
-- See `:help mini.deps` or https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md for more info
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })



-- [[ Manage plugins ]] --
local add = MiniDeps.add

-- Vimscript plugin does not need `require('<plugin>').setup()`
-- Detect indentations automatically
add('tpope/vim-sleuth')

-- Install solarized8 theme
-- It is minimalistic and do not cause strains to the eyes
add({
  source = 'lifepillar/vim-solarized8', checkout = 'neovim',
})
vim.opt.background = 'dark' -- or 'light'
vim.cmd.colorscheme 'solarized8_flat'
vim.cmd.highlight('WinSeparator guibg=NONE')
-- uncomment following line if you want transparent background
-- vim.cmd.highlight('Normal guibg=NONE')

-- Install a statusline theme
-- A minimalistic look for lualine.nvim
-- vim.api.nvim_set_hl(0, 'WinBar', {link = 'NormalFloat'})
-- vim.o.winbar = '%=%m %t '
add('nvim-lualine/lualine.nvim')
require('lualine').setup({
  options = {
    section_separators = '',
    component_separators = '',
    icons_enabled = false,
    -- Set true if only one global status line at bottom is desired
    -- Also can be set independently with :set laststatus=3, see :h laststatus
    globalstatus = true,
  },
  sections = {
    lualine_c = {{'filename', path = 3}},
  },
})

-- Uncomment following lines if you want the default lualine looks
-- add({
--   source = 'nvim-lualine/lualine.nvim',
--   depends = { 'nvim-tree/nvim-web-devicons' },
-- })
-- require('lualine').setup({
--   options = {
--     component_separators = { left = '', right = ''},
--     section_separators = { left = '', right = ''},
--   },
-- })

-- Install key bindings helper
-- add('folke/which-key.nvim')
-- require('which-key').setup()
-- require('which-key').register({
--   ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
-- })

-- Install fuzzy finder
add({
  source = 'nvim-telescope/telescope.nvim',
  depends = { 'nvim-lua/plenary.nvim' },
})
require('telescope').setup()
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', function() builtin.find_files({ hidden = true }) end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = "[S]earch Recent Files ('.' for repeat)" })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
