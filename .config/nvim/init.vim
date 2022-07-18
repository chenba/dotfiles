set nocompatible
set clipboard+=unnamedplus
set ignorecase
set smartcase
set incsearch
set number

filetype plugin indent on
syntax enable

"{{{ vim-plug
call plug#begin()

  Plug 'machakann/vim-sandwich'
  Plug 'tommcdo/vim-exchange'
  Plug 'tpope/vim-commentary'

call plug#end()
"}}}

"{{{Look and Feel

syntax enable
colorscheme slate

set showmatch
set number

"}}}

"{{{ Mappings

" Moving around mah split'd windows.
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

if exists('g:vscode')
  nmap <silent> gd <Cmd>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>
  nmap <silent> gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
  nmap <silent> go <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
  nmap <silent> gt <Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>
endif

"}}}
