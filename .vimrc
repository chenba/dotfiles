set nocompatible
"{{{managed plugins with dein

set runtimepath+=/home/chenba/.cache/vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/chenba/.cache/vim/dein')
  call dein#begin('/home/chenba/.cache/vim/dein')

  " Let dein manage dein
  call dein#add('/home/chenba/.cache/vim/dein/repos/github.com/Shougo/dein.vim')

  call dein#add('Shougo/deoplete.nvim')

  " Files and buffers
  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

  " call dein#add('tpope/vim-eunuch')
  call dein#add('rking/ag.vim')
  call dein#add('christoomey/vim-tmux-navigator')

  " Git
  call dein#add('tpope/vim-fugitive')
  call dein#add('airblade/vim-gitgutter')

  " Rust
  call dein#add('rust-lang/rust.vim')

  call dein#add('vim-syntastic/syntastic')
  call dein#add('majutsushi/tagbar')
  call dein#add('jiangmiao/auto-pairs')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" Install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"{{{Misc Settings

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

" Completion.
set ofu=syntaxcomplete#Complete
set completeopt=longest,menuone

" Tab completion.
set wildmenu
set wildmode=list:longest,full

" Enable mouse support.
set mouse=a

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

hi StatusLine ctermfg=235
hi StatusLine ctermbg=148

" }}}

"{{{ Mappings

let mapleader=","

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

inoremap <M-o> <Esc>o
inoremap <C-j> <Down>

" }}}

"{{{ Plugin Settings

let g:syntastic_check_on_open=1

" }}}

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


