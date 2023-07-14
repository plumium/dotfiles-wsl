let &t_EI = "\e[2 q"
let &t_SI = "\e[6 q"

set encoding=utf-8

set number
set cursorline

set showcmd
set showmatch
set scrolloff=5

set ignorecase
set smartcase
set hlsearch
set incsearch

set splitbelow

set wildmenu
set wildmode=longest,list,full

set expandtab
set tabstop=4
set shiftwidth=0

nnoremap x "_x
nnoremap X "_X
nnoremap s "_s
nnoremap S "_S
nnoremap <silent> <F5> :source $MYVIMRC<CR>

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'tomasiser/vim-code-dark'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'

call plug#end()

colorscheme codedark
syntax enable

