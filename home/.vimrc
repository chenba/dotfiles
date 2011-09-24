"{{{Misc Settings

set nocompatible
set encoding=utf-8
set showcmd
set showmode

filetype on
filetype plugin on
filetype indent on

set autoindent
set backspace=indent,eol,start

" Spaces instead of tabs
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

" Completion.
set ofu=syntaxcomplete#Complete
set completeopt=longest,menuone,preview

" Tab completion.
set wildmenu
set wildmode=list:longest,full

" Enable mouse support.
set mouse=a
set ttymouse=xterm2

" Searches.
set ignorecase
set smartcase
set incsearch

set hidden
set history=50

" This should work on linux or osx (vim 7.3.74+).
" let g:clipbrdDefaultReg = '+'

" }}}

"{{{Look and Feel

syntax enable
colorscheme slate

set showmatch
set number
set ruler
set laststatus=2 statusline=%02n:%<%f\ %{fugitive#statusline()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" }}}

"{{{ Mappings

let mapleader=","

" Swap ; and :
nnoremap ; :
nnoremap : ;

" Toggle line numbers.
nnoremap <C-N> :set number!<CR>

" Moving around mah split'd windows.
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" Space will toggle folds.
nnoremap <space> za

" Search mappings: These will make it so that going to the next match
" will center on the line it's found in.
map N Nzz
map n nzz

map <F3> :cn<CR>
map <F4> :cp<CR>

" }}}

"{{{Autocmd

" Remove trailing whitespace
autocmd BufReadPost,BufWritePre * if ! &bin | silent! %s/\s\+$//ge | endif

" Automatically cd into the directory that the file is in
" autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

"{{{Filetypes

autocmd FileType ruby setlocal softtabstop=2 shiftwidth=2
autocmd FileType scss setl syntax=css tabstop=2 shiftwidth=2
autocmd FileType php noremap <F10> :w<CR>:!php -l %<CR>
autocmd FileType ctp noremap <F10> :w<CR>:!php -l %<CR>

function MyBufEnter()
  " don't (re)store filepos for git commit message files
  if &filetype == "gitcommit"
    call setpos('.', [0, 1, 1, 0])
  endif
endfunction
au BufEnter * call MyBufEnter()

" }}}

" }}}

"{{{Plugin settings

let g:bufExplorerSortBy='fullpath'   " Sort by full file path name.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSplitOutPathName=0
let g:ConqueTerm_EscKey = '<C-y>'

" }}}
