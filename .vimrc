" Installation Note: 
" 1) Delete msvcrc90.dll in python.exe, otherwise it will conflict with
" system one and cause R6034 runtime error
set runtimepath+=~/vimfiles/

set langmenu=en_US
language messages en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
" DitX rending
set rop=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1

" Pathogen 
execute pathogen#infect()
"call pathogen#helptags() " generate helptags for everything in 'runtimepath'


syntax on
filetype plugin indent on

" GUI setting
if has('gui_running')
  set guifont=Consolas:h10
  set guioptions=gm "no scrollbar,toolbar
endif
set number


" use system clipboard with yank/paste
set clipboard+=unnamed
set paste
set hidden " hide buffer without saving to a file
set scrolloff=30
" auto find tags files in the parent dir
set tags=./tags;/
" change local buffer working directory to the edited file
autocmd BufEnter * silent! lcd %:p:h
" line wrap will keep indent
set breakindent
set breakindentopt=shift:1
set linebreak
set textwidth=100
set colorcolumn=100
set tabstop=4 softtabstop=0 shiftwidth=4
"----- Key Bindings ----- <<<
set winaltkeys=no
let mapleader = " "
let maplocalleader = ","

noremap  <buffer> <silent> <Up> gk
noremap  <buffer> <silent> <Down> gj

" quick select paste text
noremap gV `[v`]
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" in visual mode, swap 's' (substitute) and 'S' (suround)
vnoremap s S
vnoremap S s
" smart Home key <<<
nmap <silent><Home> :call SmartHome("n")<CR>
nmap <silent><End> :call SmartEnd("n")<CR>
imap <silent><Home> <C-r>=SmartHome("i")<CR>
imap <silent><End> <C-r>=SmartEnd("i")<CR>
vmap <silent><Home> <Esc>:call SmartHome("v")<CR>
vmap <silent><End> <Esc>:call SmartEnd("v")<CR>

function SmartHome(mode)
  let curcol = col(".")
  "gravitate towards beginning for wrapped lines
  if curcol > indent(".") + 2
    call cursor(0, curcol - 1)
  endif
  if curcol == 1 || curcol > indent(".") + 1
    if &wrap
      normal g^
    else
      normal ^
    endif
  else
    if &wrap
      normal g0
    else
      normal 0
    endif
  endif
  if a:mode == "v"
    normal msgv`s
  endif
  return ""
endfunction

function SmartEnd(mode)
  let curcol = col(".")
  let lastcol = a:mode == "i" ? col("$") : col("$") - 1
  "gravitate towards ending for wrapped lines
  if curcol < lastcol - 1
    call cursor(0, curcol + 1)
  endif
  if curcol < lastcol
    if &wrap
      normal g$
    else
      normal $
    endif
  else
    normal g_
  endif
  "correct edit mode cursor position, put after current character
  if a:mode == "i"
    call cursor(0, col(".") + 1)
  endif
  if a:mode == "v"
    normal msgv`s
  endif
  return ""
endfunction
" >>>

"----- Buffer related

" Ctrl-W to close current buffer
nnoremap <leader>bd :confirm bd<CR> 
nnoremap <C-w> :bd<CR>
nnoremap <leader>bb :CtrlPBuffer<CR>

"----- Windows Management
"close window
nnoremap <leader>wc <C-w>c
"maximize current window
nnoremap <leader>ww <C-w>o
nnoremap <C-Down> <C-w>j
nnoremap <C-Up> <C-w>k
nnoremap <C-Left> <C-w>h
nnoremap <C-Right> <C-w>l



"-----  Folding
nnoremap zz za
nnoremap za zz

source ~/vimfiles/cua-mode.vim
" >>>

"----- Plugin Config ----- <<<

" buftabline <<<
"let g:buftabline_numbers=1
" >>>


"" SimplyFold <<<
"let g:SimpylFold_fold_import = 1
"let g:SimpylFold_docstring_preview = 1
"autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
"autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<
"" >>>

"---------- NerdTree and NERDTreeTabs ---------- <<<
nnoremap <leader>nn :NERDTreeToggle<CR>
"close vim if the only window left open is a NERDTree
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" >>>

"---------- Syntastic ---------- <<<
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
    let g:syntastic_mode_map = {
        \ "mode": "passive",
        \ "active_filetypes": ["ruby", "php"],
        \ "passive_filetypes": ["puppet"] }

" >>>

"---------- Airline ---------- <<<
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tagbar#enabled = 1

let g:airline#extensions#ctrlp#show_adjacent_modes = 1
let g:airline#extensions#csv#enabled = 1
let g:airline#extensions#tabline#enabled = 1 "Automatically displays all buffers when there's only one tab open.
let g:airline#extensions#tabline#buffer_nr_show = 1
  let g:airline#extensions#tabline#show_buffers = 1
  let g:airline#extensions#tabline#switch_buffers_and_tabs = 0
  let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
" >>>

"---------- color theme ---------- <<<
set background=dark
colorscheme solarized
" >>>

"---------- Tagbar ---------- <<<
nnoremap <leader>tt :TagbarToggle<CR>
let g:tagbar_autofocus = 1
" >>>

"---------- Tab Align ---------- <<<
if exists(":Tabularize")
	nmap <Leader>a= :Tabularize /=<CR>
	vmap <Leader>a= :Tabularize /=<CR>
	nmap <Leader>a: :Tabularize /:\zs<CR>
	vmap <Leader>a: :Tabularize /:\zs<CR>
endif
" >>>

"---------- CtrlP ---------- <<<
let g:ctrlp_user_command=""

let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v(c:/Users/.*|[\/]\.(git|hg|svn))$',
	\ 'file': '\v\.(exe|so|dll)$',
	\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
	\ }

let g:ctrlp_max_files = 10000
let g:ctrlp_max_depth = 3
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 
                      \  'line', 'changes', 'mixed', 'bookmarkdir']
let g:ctrlp_cmd = 'CtrlPMixed'

nnoremap <leader>pp :CtrlPTag<CR>
nnoremap <leader>pm :CtrlPBookmarkDir<CR>
nnoremap <leader>pb :CtrlPBuffer<CR>
" >>>

"---------- UltiSnips ---------- <<<
let g:UltiSnipsExpandTrigger="<A-/>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" >>>

"---------- Neocomplete ---------- <<<
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
  "return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  "" For no inserting <CR> key.
  ""return pumvisible() ? "\<C-y>" : "\<CR>"
"endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<C-Tab>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<BS>"
" Close popup by <Space>.
inoremap <expr><Space> pumvisible() ? "\<C-y>" . "\<Space>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=jedi#completions
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" in python, use jedi complete
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 1
let g:jedi#smart_auto_mappings = 0
if !exists('g:neocomplete#force_omni_input_patterns')
	let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python =
\ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" alternative pattern: '\h\w*\|[^. \t]\.\w*'

" >>>

"---------- Jedi-vim ---------- <<<
let g:jedi#goto_command = "<localleader>gg"
let g:jedi#goto_assignments_command = "<localleader>ga"
let g:jedi#goto_definitions_command = "<localleader>gd"
let g:jedi#documentation_command = "<localleader>h"
let g:jedi#usages_command = "<localleader>i"
"let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<localleader>r"
" >>>

"---------- Indent Guide Lines ---------- <<<
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
" >>>

"---------- Undo Tree ---------- <<<
nnoremap <leader>uu :GundoToggle<CR>
" >>>



"---------- rainbow_parentheses ---------- <<<
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" >>>

"---------- https://github.com/terryma/vim-expand-region <<<
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
"map + <Plug>(expand_region_expand)
"map _ <Plug>(expand_region_shrink)
" Extend the global default (NOTE: Remove comments in dictionary before sourcing)
call expand_region#custom_text_objects({
			\ "\/\\n\\n\<CR>": 1, 
			\ 'a]' :1, 
			\ 'ab' :1, 
			\ 'aB' :1, 
			\ 'ii' :0, 
			\ 'ai' :0, 
			\ })
" >>>

" >>>



" Python file Setting <<<
au FileType python map <silent> <localleader>b ofrom IPython.core.debugger import Tracer<CR>Tracer()()<esc>

" >>>

" vim: set fdm=marker fmr=<<<,>>> fdl=0:
