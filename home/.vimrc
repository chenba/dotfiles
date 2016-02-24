set nocompatible
filetype off

set rtp+=$GOROOT/misc/vim
set rtp+=~/.vim/bundle/neobundle.vim

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

"{{{managed bundles

" Github
NeoBundle 'Raimondi/delimitMate'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'bling/vim-airline'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'danro/rename.vim'
NeoBundle 'elzr/vim-json'
NeoBundle 'guns/vim-clojure-static'
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'kana/vim-fakeclip'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'marijnh/tern_for_vim'
NeoBundle 'mxw/vim-jsx'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'rking/ag.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tpope/vim-fireplace'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-obsession'
NeoBundle 'tpope/vim-salve'
NeoBundle 'tpope/vim-surround'
NeoBundle 'venantius/vim-cljfmt'
NeoBundle 'venantius/vim-eastwood'
NeoBundle 'vim-scripts/paredit.vim'
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/neocomplete.vim'

"Vim-script
NeoBundle 'bufexplorer.zip'

"}}}

call neobundle#end()
NeoBundleCheck

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
set completeopt=longest,menuone

" Tab completion.
set wildmenu
set wildmode=list:longest,full

" Enable mouse support.
set mouse=a

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
map <C-F5> <C-W>_<C-W><Bar>

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

nnoremap <F3> :cn<CR>
nnoremap <F4> :cp<CR>

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>""

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
" Disable AutoComplPop.
let g:acp_enableAtStartup=1
" Use neocomplete.
let g:neocomplete#enable_at_startup=1
" Use smartcase.
let g:neocomplete#enable_smart_case=1

inoremap <M-o> <Esc>o
inoremap <C-j> <Down>

" }}}
