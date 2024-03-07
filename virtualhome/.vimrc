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
Plug 'guns/xterm-color-table.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
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
set splitright
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

autocmd! BufReadPre *.go
      \ let g:vsnip_snippet_dir = '$HOME/.vim/snippets' |
      \ let g:go_highlight_functions = 1 |
      \ let g:go_highlight_function_calls = 1 |
      \ let g:go_highlight_types = 1 |
      \ let g:go_highlight_operators = 1 |
autocmd! FileType go 
      \ hi goFunction ctermfg=214 ctermbg=NONE |
      \ hi goFunctionCall ctermfg=110 ctermbg=NONE |
      \ hi goTypeName ctermfg=140 ctermbg=NONE |
      \ hi goTypeConstructor ctermfg=140 ctermbg=NONE |
      \ hi goOperator ctermfg=110 ctermbg=NONE |
      \ syntax match Bracket /\[\|\]/ |
      \ hi Bracket ctermfg=185

if !empty(globpath(&rtp, 'autoload/lsp.vim'))
  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> <F2> <plug>(lsp-rename)
    nmap <buffer> = <plug>(lsp-document-format)
    nmap <buffer> gd <plug>(lsp-peek-definition)
    nmap <buffer> gh <plug>(lsp-hover)
    nmap <buffer> <C-I> <plug>(lsp-implementation)
    nmap <buffer> <C-K> <plug>(lsp-code-action)
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
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

nnoremap <silent> <F5> :w<CR>:source $MYVIMRC<CR>:e %<CR>:noh<CR>
nnoremap <silent> <C-[><C-[> :noh<CR>
nnoremap <silent> <Space><Space> :let @/ = '\<' . expand('<cword>') . '\>'<CR>:set hlsearch<CR>
nnoremap gb :bn<CR>
nnoremap gB :bp<CR>
nnoremap <leader>b :ls<CR>
nnoremap ]] ]m
nnoremap [[ [m
nmap <Space>h <Space><Space>:%s/<C-r>///g<Left><Left>
cnoremap <C-a> <C-b>

inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

function! PrintSyntaxGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfunction

