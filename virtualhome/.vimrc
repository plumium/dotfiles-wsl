" Setup vim-plug https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'cocopon/iceberg.vim'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-surround'
Plug 'obcat/vim-sclow'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()

let &t_SI = "\e[3 q"
let &t_EI = "\e[1 q"
autocmd! CmdlineEnter * call echoraw(&t_SI)
autocmd! CmdlineLeave * call echoraw(&t_EI)
let g:airline_section_b = '%{strftime("%c")}'

set encoding=utf-8
set number
set showcmd
set showmatch
set scrolloff=0
set ignorecase
set smartcase
set hlsearch
set incsearch
set splitbelow
set wildmenu
set wildmode=longest,list,full
set expandtab
set tabstop=2
set shiftwidth=0

syntax on
autocmd! ColorScheme iceberg
      \ hi Normal ctermbg=NONE |
      \ hi LineNr ctermfg=140 ctermbg=NONE |
      \ hi SclowsBar ctermbg=140
colorscheme iceberg
set background=dark

if !empty(globpath(&rtp, 'autoload/lsp.vim'))
  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap gd <plug>(lsp-definition)
    nmap <f2> <plug>(lsp-rename)
    nmap = <plug>(lsp-document-format)
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
  endfunction
  augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END
  command! LspDebug
        \ let lsp_log_verbose=1 |
        \ let lsp_log_file = expand('~/lsp.log')
  let g:lsp_diagnostics_enabled = 1
  let g:lsp_diagnostics_echo_cursor = 1
endif

nnoremap <silent> <F5> :w<CR>:source $MYVIMRC<CR>:noh<CR>
nnoremap <silent> <C-[><C-[> :noh<CR>
nnoremap <silent> <Space><Space> :let @/ = '\<' . expand('<cword>') . '\>'<CR>:set hlsearch<CR>
nnoremap gb :bn<CR>
nnoremap gB :bp<CR>
nnoremap <leader>b :ls<CR>
nnoremap ]] ]m
nnoremap [[ [m
nmap <Space>h <Space><Space>:%s/<C-r>///g<Left><Left>
cnoremap <C-a> <C-b>

