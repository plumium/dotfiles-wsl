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

colorscheme zellner
syntax enable
highlight clear CursorLine

nnoremap x "_x
nnoremap X "_X
nnoremap s "_s
nnoremap S "_S

