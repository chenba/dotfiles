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

  if (!exists('g:vscode'))
    Plug 'tpope/vim-commentary'
  endif

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
