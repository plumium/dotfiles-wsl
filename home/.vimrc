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
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'guns/xterm-color-table.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'sqls-server/sqls.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'mattn/vim-sonictemplate'
Plug 'sebdah/vim-delve'
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

" Set the default listing style to tree.
let g:netrw_liststyle = 3

" Make vertical splitting the default for previewing files.
" Split the preview window into the right side.
let g:netrw_preview = 1
let g:netrw_alto = 0

" When a vertical preview window is opened, the directory listing
" will use only 20% of the columns available; the rest of the window
" is used for the preview window.
let g:netrw_winsize = 20

command! BufOnly .+,$bdelete

fun! GetPopupId(n)
  let pops = popup_list()
  if len(pops) == 0
    return -1
  endif
  return pops[a:n]
endfun

fun! PopupScroll(id,n)
  let pos = popup_getpos(a:id)
  let firstline = pos.firstline + a:n
  if firstline < 1
    let firstline = 1
  elseif firstline > pos.lastline
    let firstline = pos.lastline
  endif
  call popup_setoptions(a:id, {'firstline': firstline})
endfun

fun! PopupFilterScroll(id, key)
  if a:key == "j"
    call PopupScroll(a:id,1)
    return 1
  endif
  if a:key == "\<C-D>"
    call PopupScroll(a:id,10)
    return 1
  endif
  if a:key == "k"
    call PopupScroll(a:id,-1)
    return 1
  endif
  if a:key == "\<C-U>"
    call PopupScroll(a:id,-10)
    return 1
  endif
  if a:key =="x"
    call popup_close(a:id)
    return 1
  endif
  return 0
endfun

fun! AttachPopupScroller(id) abort
  " Want to handle the time when a popup window is opened.
  " There is a possibility that the first element might be not
  " opened popup window.
  let winid = GetPopupId(0)
  if winid > 0
    call timer_stop(a:id)
    call popup_setoptions(winid, #{filter: 'PopupFilterScroll'})
  endif
endfun

set t_Co=256
syntax on
autocmd! ColorScheme iceberg
      \ hi Normal ctermbg=NONE |
      \ hi LineNr ctermfg=140 ctermbg=NONE |
      \ hi SclowsBar ctermbg=140
colorscheme iceberg
set background=dark

" Meta and special keys listed with ':map'
hi! link SpecialKey Special

autocmd! BufReadPre *.go
      \ let g:vsnip_snippet_dir = '$HOME/.vim/snippets' |
      \ let g:go_highlight_functions = 1 |
      \ let g:go_highlight_function_calls = 1 |
      \ let g:go_highlight_types = 1 |
      \ let g:go_highlight_operators = 1 |

fun! s:on_go_loaded() abort
  hi goFunction ctermfg=214 ctermbg=NONE
  hi goFunctionCall ctermfg=110 ctermbg=NONE
  hi goTypeName ctermfg=140 ctermbg=NONE
  hi goTypeConstructor ctermfg=140 ctermbg=NONE
  hi goOperator ctermfg=110 ctermbg=NONE
  syntax match Bracket /\[\|\]/
  hi Bracket ctermfg=185
endfun
autocmd! FileType go call s:on_go_loaded()

if !empty(globpath(&rtp, 'autoload/lsp.vim'))
  fun! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> <F2> <plug>(lsp-rename)
    nmap <buffer> = <plug>(lsp-document-format)
    " lsp_float_opend and lsp#document_hover_preview_winid
    " did not work as expected with lsp-peek-definition.
    nmap <buffer> gd <plug>(lsp-peek-definition)
          \ :call timer_start(100, 'AttachPopupScroller', {})<CR>
    nmap <buffer> gD <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> gh <plug>(lsp-hover)
    nmap <buffer> gk <plug>(lsp-code-action)
    nmap <buffer> g[ <plug>(lsp-previous-diagnostic)
    nmap <buffer> g] <plug>(lsp-previous-diagnostic)
    inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"
    autocmd! BufWritePre <buffer>
          \ call execute('LspCodeActionSync source.organizeImports') |
          \ LspDocumentFormatSync
  endfun
  if executable('gopls')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'gopls',
          \ 'cmd': {server_info->['gopls']},
          \ 'allowlist': ['go'],
          \ })
  endif
  if executable('pylsp')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'pylsp',
          \ 'cmd': {server_info->['pylsp']},
          \ 'allowlist': ['python'],
          \ 'config': {'pylsp': {'plugins': {'autopep8': {'enabled': v:false}}}},
          \ })
  endif  
  if executable('sqls')
    au User lsp_setup call lsp#register_server({
          \   'name': 'sqls',
          \   'cmd': {server_info->['sqls']},
          \   'allowlist': ['sql'],
          \ })
  endif
  augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END
  command! LspDebug
        \ let lsp_log_verbose=1 |
        \ let lsp_log_file = expand('~/lsp.log') |
        \ :vnew | execute "ter ++curwin tail -f " . expand('~/lsp.log') |
        \ :wincmd p
  let g:lsp_diagnostics_enabled = 1
  let g:lsp_diagnostics_echo_cursor = 1
  let g:lsp_diagnostics_float_cursor = 1
endif

nnoremap <silent> <F5> :w<CR>:source $MYVIMRC<CR>:e %<CR>:let @/ = ''<CR>
nnoremap <silent> <C-[><C-[> :noh<CR>
nnoremap <silent> <Space><Space> :let @/ = '\<' . expand('<cword>') . '\>'<CR>:set hlsearch<CR>
nmap <Space>h <Space><Space>:%s/<C-r>///g<Left><Left>
cnoremap <C-a> <C-b>
nnoremap <silent> <F3> :Lexplore<CR>

inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

let g:sonictemplate_vim_template_dir = '$HOME/.vim/sonictemplate'
let s:postfix_cache = {}
fun! s:get_postfix_pattern_path(filetype)
  return expand(join([
        \ g:sonictemplate_vim_template_dir,
        \ a:filetype,
        \ 'pattern.stpl'], '/'))
endfun

fun! s:get_postfix(filetype) abort
  if has_key(s:postfix_cache, a:filetype)
    return s:postfix_cache[a:filetype]
  endif
  let l:stpl = s:get_postfix_pattern_path(a:filetype)
  if !filereadable(l:stpl)
    return {}
  endif
  let s:postfix_cache[a:filetype] = {}
  let l:k = ''
  let l:v = []
  for l:line in add(readfile(l:stpl), '__END__')
    if l:line ==# ''
      continue
    elseif l:line !~# '^\t'
      if l:k !=# ''
        let s:postfix_cache[a:filetype][l:k] = l:v
      endif
      let l:k = l:line
      let l:v = []
    else
      call add(l:v, l:line[1:])
    endif
  endfor
  return s:postfix_cache[a:filetype]
endfun

fun! s:exists_postfix_entry(expr, filetype) abort
  let l:p = s:get_postfix(a:filetype)
  if l:p == {}
    return 0
  endif
  let l:c = keys(l:p)
        \ ->map({_,v -> matchstr(a:expr, v)})
        \ ->filter({_,v -> v != ''})
        \ ->len()
  return l:c ># 0
endfun

fun! s:handle_imap_tab()
  if vsnip#jumpable(1)
    return "\<Plug>(vsnip-jump-next)"
  endif
  let l:compArg = getline('.')[:col('.')]
  if s:exists_postfix_entry(l:compArg, &filetype)
    return "\<plug>(sonictemplate-postfix)"
  endif
  return "\<Tab>"
endfun

imap <expr> <Tab> <SID>handle_imap_tab()
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

fun! PrintSyntaxGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

command! -nargs=? PostfixOpenVsplit call s:open_postfix('vsplit', <q-args>)
fun! s:open_command(cmd, args)
  execute printf('%s %s', a:cmd, a:args)
endfun
fun! s:open_postfix(cmd, arg)
  call s:open_command(a:cmd, a:arg != ''
        \ ? s:get_postfix_pattern_path(a:arg)
        \ : s:get_postfix_pattern_path(&filetype))
endfun
