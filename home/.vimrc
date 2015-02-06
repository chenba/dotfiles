set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"{{{Vundle managed bundles

" Github
Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'kien/ctrlp.vim'
Bundle 'danro/rename.vim'
Bundle 'kana/vim-fakeclip'
Bundle 'airblade/vim-gitgutter'
Bundle 'scrooloose/syntastic'
Bundle 'Valloric/YouCompleteMe'
Bundle 'rking/ag.vim'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'Raimondi/delimitMate'
Bundle 'marijnh/tern_for_vim'
Bundle 'pangloss/vim-javascript'
Bundle 'jelera/vim-javascript-syntax'

"Vim-script
Bundle 'bufexplorer.zip'
" Bundle 'Tagbar' // SUCKS WHEN OPENING LARGE JS FILES

"}}}

"{{{Misc Settings

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

" Clipboard! Should work on OSX with 7.3+
set clipboard=unnamed

" Searches.
set ignorecase
set smartcase
set incsearch

set hidden
set history=50

set wildignore+=*/tmp/*,*.so,*.swp,*.swo,*.zip

" }}}

"{{{Look and Feel

syntax enable
colorscheme slate

set showmatch
set number
set ruler
set laststatus=2 statusline=%02n:%<%f\ %h%m%r%=%{fugitive#statusline()}\ %{SyntasticStatuslineFlag()}\ %-8.(%l,%c%V%)\ %P

hi StatusLine ctermfg=Gray
hi StatusLine ctermbg=Red

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

" auto indent when paste
nnoremap >< V`]>
nnoremap <lt>> V`]<
nnoremap =- V`]=

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
function! StripTrailingWhitespace()
  normal mZ
  let l:chars = col("$")
  %s/\s\+$//e
  if (line("'Z") != line(".")) || (l:chars != col("$"))
    echo "Trailing whitespace stripped\n"
  endif
  normal `Z
endfunction
autocmd BufWritePre * :call StripTrailingWhitespace()

" Automatically cd into the directory that the file is in
" autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

"{{{Filetypes

autocmd FileType ruby setlocal softtabstop=2 shiftwidth=2

function! MyBufEnter()
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
let g:ctrlp_custom_ignore = {
    \ 'dir':    '\.git$\|docs$\|public$\|node_modules$',
    \ }
let g:syntastic_check_on_open=1
let g:fakeclip_terminal_multiplexer_type='tmux'
let g:ycm_add_preview_to_completeopt=0
let g:ycm_confirm_extra_conf=0
let g:ycm_autoclose_preview_window_after_completion=1

inoremap <M-o> <Esc>o
inoremap <C-j> <Down>

" }}}
