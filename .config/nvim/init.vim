set nocompatible
set clipboard+=unnamedplus
set ignorecase
set smartcase
set incsearch
set number

filetype plugin indent on
syntax enable

"{{{ dein
" Required:
set runtimepath+=/Users/barrychen/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('/Users/barrychen/.cache/dein')

" Let dein manage dein
" Required:
call dein#add('/Users/barrychen/.cache/dein/repos/github.com/Shougo/dein.vim')

call dein#add('machakann/vim-sandwich')
call dein#add('tommcdo/vim-exchange')
call dein#add('tpope/vim-commentary')

call dein#end()

if dein#check_install()
  call dein#install()
endif

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

"}}}
