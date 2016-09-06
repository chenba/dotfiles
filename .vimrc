set nocompatible
filetype off

"{{{managed plugins with dein

set rtp^=~/.config/nvim/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.cache/dein'))

call dein#add('Shougo/dein.vim')
call dein#add('Shougo/deoplete.nvim')
call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })
call dein#add('jlanzarotta/bufexplorer')
call dein#add('tpope/vim-eunuch')
call dein#add('rking/ag.vim')
call dein#add('christoomey/vim-tmux-navigator')
call dein#add('bling/vim-airline')
call dein#add('jiangmiao/auto-pairs')
call dein#add('scrooloose/syntastic')
call dein#add('scrooloose/nerdcommenter')

" Git
call dein#add('tpope/vim-fugitive')
call dein#add('airblade/vim-gitgutter')

" JavaScript
call dein#add('marijnh/tern_for_vim')
call dein#add('jelera/vim-javascript-syntax')
call dein#add('pangloss/vim-javascript')

call dein#end()

if dein#check_install()
  call dein#install()
endif

"}}}

"{{{Misc Settings

filetype plugin indent on

set encoding=utf-8
set showcmd
set showmode

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

" fzf
nnoremap <C-P> :FZF<CR>

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
let g:syntastic_check_on_open=1
" Disable AutoComplPop.
let g:acp_enableAtStartup=1
" Use deoplete.
let g:deoplete#enable_at_startup = 1
inoremap <M-o> <Esc>o
inoremap <C-j> <Down>

" }}}
