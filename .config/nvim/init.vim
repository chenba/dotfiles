set nocompatible
set confirm
set vb

set clipboard+=unnamedplus
set undofile

set ignorecase
set smartcase
set incsearch

set number
set colorcolumn=80
set scrolloff=3
set signcolumn=yes

set wildmenu
set wildmode=list:longest,full
set wildoptions=pum

set encoding=utf-8
set showcmd
set showmode

set autoindent
set backspace=indent,eol,start

" Spaces instead of tabs
set expandtab
set smarttab
set shiftwidth=2
set softtabstop=2

filetype plugin indent on
syntax enable

autocmd BufLeave,FocusLost * silent! wall

lua << EOF
  vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })
EOF

"{{{ vim-plug
call plug#begin()

  Plug 'machakann/vim-sandwich'
  Plug 'tommcdo/vim-exchange'
  Plug 'tpope/vim-repeat'
  Plug 'unblevable/quick-scope'
  Plug 'nvim-lualine/lualine.nvim'

  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'

  Plug 'folke/noice.nvim'
  Plug 'MunifTanjim/nui.nvim'

  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'

  " Color scheme
  Plug 'morhetz/gruvbox'

  if (!exists('g:vscode'))
    Plug 'knubie/vim-kitty-navigator', {'do': 'cp ./*.py ~/.config/kitty/'}
    Plug 'tpope/vim-commentary'
  endif

call plug#end()
"}}}

"{{{Look and Feel

colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'

set showmatch
set number

"}}}

"{{{ Mappings

let mapleader=","

nnoremap ; :
nnoremap : ;

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fr <cmd>Telescope lsp_references<cr>
nnoremap <leader>fo <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>ft <cmd>Telescope lsp_workspace_symbols<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

if exists('g:vscode')
  map <C-J> <C-W>j
  map <C-K> <C-W>k
  map <C-H> <C-W>h
  map <C-L> <C-W>l

  vnoremap <leader>ff <cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>
  nmap <silent> gf <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>

  nmap <silent> gd <Cmd>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>
  nmap <silent> gy <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
  nmap <silent> gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
  nmap <silent> go <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
  nmap <silent> gt <Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>
  nmap <silent> gn <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>
  nmap <silent> gp <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>
  nmap <silent> ge <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>

  xmap gc  <Plug>VSCodeCommentary
  nmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine
endif

"}}}

if exists('g:vscode')
  highlight QuickScopePrimary guifg='#58822f' gui=underline ctermfg=155 cterm=underline
  highlight QuickScopeSecondary guifg='#3aa0a6' gui=underline ctermfg=81 cterm=underline
endif

if !exists('g:vscode')
lua << EOF
  local cmp = require('cmp')
  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'path' },
    }, {
      { name = 'buffer' },
    }),
  })
                                        
  vim.o.completeopt = 'menu,menuone,noselect'

  local lsp = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  local lsp_flags = { debounce_text_changes = 150 }

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format({ async = true }) end, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
  end

  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = { "rust_analyzer", "ts_ls" },
    automatic_installation = false,
  })

  lsp.ts_ls.setup({
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  })

  lsp.rust_analyzer.setup({
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    filetypes = { "rust" },
    root_dir = lsp.util.root_pattern("Cargo.toml", ".git"),
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        -- Optional: run clippy on save (newer setting name)
        check = { command = "clippy" },
      },
    },
  })

  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
  
  require("noice").setup({
    views = {
      hover = {
        size = {
          max_height = 30,
          max_width = 80,
        },
      },
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    cmdline = {
      view = "cmdline",
    },
  })
EOF
endif
