" ----------------------------------------------------------------------------
" Misc Editor
" ----------------------------------------------------------------------------

" set shell=/bin/bash

set nocompatible
set nobackup
set noswapfile
filetype on
filetype indent plugin on
compiler ruby
" set regexpengine=2
au FileType cpp set mps+=<:>
" Always start on first line in git commit message
"autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

set timeout timeoutlen=1000 ttimeoutlen=100

" open split to the bottom and to the right
set splitbelow
set splitright

" merge sign column (lint/build messages) with number column
set signcolumn=number

" ----------------------------------------------------------------------------
"  Text Formatting
" ----------------------------------------------------------------------------

"set foldmethod=manual
set nofoldenable
set autoindent             " automatic indent new lines
set nowrap                 " do not wrap lines
set softtabstop=2          " yep, two
set shiftwidth=2           " ..
set tabstop=4
set expandtab              " expand tabs to spaces
set nosmarttab             " fuck tabs
set formatoptions+=n       " support for numbered/bullet lists
set textwidth=80           " wrap at 80 chars by default
set virtualedit=block      " allow virtual edit in visual block ..

" ----------------------------------------------------------------------------
" Editing
" ----------------------------------------------------------------------------

" lead with ,
let mapleader = ","

"inoremap ` <ESC>
"vnoremap ` <ESC>
"cnoremap ` <ESC>

" reflow paragraph with Q in normal and visual mode
"nnoremap Q gqap
"vnoremap Q gq

" Next/prev match for "f" or "t" motions
nnoremap - ,
nnoremap = ;

" Don't use arrows
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Use ; instead of : to type commands
nnoremap ; :
vnoremap ; :

" Paste without yanking
vnoremap p "_dP

nmap <leader>c :bd<cr>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Hide search highlighting
nmap <silent> <leader>. :nohlsearch<cr>

" Quickly jump between last two files
nmap <leader><leader> <C-^>

" Percent-percent expands to directory path
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" ----------------------------------------------------------------------------
"  UI
" ----------------------------------------------------------------------------

set ruler                  " show the cursor position all the time
set noshowcmd              " don't display incomplete commands
"set nolazyredraw           " turn off lazy redraw
set lazyredraw
set number                 " line numbers
set wildmenu               " turn on wild menu
set wildmode=list:longest,full
set ch=2                   " command line height
set backspace=2            " allow backspacing over everything in insert mode
set whichwrap+=<,>,h,l,[,] " backspace and cursor keys wrap to
set report=0               " tell us about changes
set nostartofline          " don't jump to the start of line when scrolling

set nocursorline
set noshowmatch            " do not jump to the matching pair when typing
set mat=5                  " duration to show matching brace (1/10 sec)
set incsearch              " do incremental searching
set hlsearch               " highlight search results. Turn off highlighting with <leader>.
set laststatus=2           " always show the status line
set ignorecase             " ignore case when searching
set t_Co=256
set statusline=%f\ %m%y%=%c,%l/%L\ %P

syntax enable
set ttyfast
set synmaxcol=200

"set synmaxcol=128
"syntax sync minlines=256

" show some special characters
set list listchars=tab:\ \ ,trail:·,nbsp:_,extends:»,precedes:«

" set termguicolors

" set background=dark
" colorscheme ir_ben
" colorscheme tender

" ----------------------------------------------------------------------------
" Configuring Vim
" ----------------------------------------------------------------------------

" Which syntax highlighting group is under the cursor
map <C-o> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Quickly open and reload .vimrc
nmap <silent> <leader>ev :e $MYVIMRC<cr>
nmap <silent> <leader>sv :so $MYVIMRC<cr>


" ----------------------------------------------------------------------------
" Custom Editing Scripts
" ----------------------------------------------------------------------------

" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion. (grb)
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" RUN CURRENT FILE
" Detects suitable command to run the current file.

function! DetectRunCommand(debug)
  let expanded_path = expand("%")
  let command = ""

  if filereadable(".vim/run")

    let command = 'BUILD_TYPE=' . (a:debug ? 'Debug' : 'Release') . " .vim/run %"

  elseif expanded_path =~ "_spec\.rb$"

    if filereadable("script/test")
      let run_command = "script/test " . expanded_path
    elseif filereadable("bin/spring")
      let run_command = "bin/spring rspec " . expanded_path
    elseif filereadable("Gemfile")
      let run_command = "bundle exec rspec " . expanded_path
    else
      let run_command = "rspec " . expanded_path
    endif

    if a:debug
      let command = run_command . ":" . line('.')
    else
      let command = run_command
    endif

  elseif expanded_path =~ "\\.rb$"

    let command = "ruby " . expanded_path

  elseif expanded_path =~ "bm-.\\+\\.cpp$"

    let command = "g++ -std=c++17 -O3 -ffast-math -mrecip=none -march=native -g % -lm -lbenchmark -lpthread && ./a.out"

  elseif expanded_path =~ "\\.cpp$"

    let command = "g++ -std=c++17 -ffast-math -mrecip=none -O2 -march=native -g % && time ./a.out"
    #let command = "g++ -std=c++17 -ffast-math -mrecip=none -O3 -march=native -g -fno-vectorize -fno-slp-vectorize % && time ./a.out"

  elseif expanded_path =~ "\\.asm$"

    let command = "g++ -O2 -march=native % && time ./a.out"

  elseif expanded_path =~ "\\.test.js$"

    let command = "jest %"

  elseif expanded_path =~ "\\.js$"

    let command = "node " . expanded_path

  elseif expanded_path =~ "\\.rs$"

    if filereadable("Cargo.toml")
      let command = "cargo run"
    else
      let command = "rustc -o a.out % && time ./a.out"
    endif

  endif

  return command
endfunction

function! RunCurrentFile(debug)
  :w

  let g:run_command = DetectRunCommand(a:debug)

  if empty(g:run_command)
    echomsg "(RunCurrentFile) Don't know how to run this file"
  else
    let title = substitute(g:run_command, "'", "\\'", "")
    exec "!clear && echo '" . title . "\\n' && " . g:run_command
  endif
endfunction

:command! -nargs=1 RunCmd let g:run_command = <q-args>

function! RepeatLastRun()
  :w

  if !exists("g:run_command") || empty(g:run_command)
    echomsg "(RepeatLastRun) No last run"
  else
    exec "!clear && " . g:run_command
  endif
endfunction

map <leader>r :call RunCurrentFile(0)<cr>
map <leader>R :call RunCurrentFile(1)<cr>
map <leader>w :call RepeatLastRun()<cr>

" RENAME/REMOVE FILE

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

function! RemoveFile()
  call delete(expand('%'))
  :bdelete
endfunction
map <leader>d :call RemoveFile()<cr>

" GO TO NEXT/PREV INDENT BLOCK
" (goes to the next equally or less indented block)
function! GoToNextIndentBlock()
  let current_line = line('.')
  let last_line = line('$')

  let target_indent = indent(current_line)
  let skip_second_loop = 0

  if target_indent == 0
    let skip_second_loop = 1
    let target_indent = 1
    let current_line = nextnonblank(current_line + 1)
  endif

  " Skip lines with the same or more indentation
  while (current_line != 0) && (current_line < last_line) && (target_indent <= indent(current_line))
    let current_line = nextnonblank(current_line + 1)
  endwhile

  if skip_second_loop == 0
    " Now go find first line with less indentation
    while (current_line != 0) && (current_line < last_line) && (target_indent > indent(current_line))
      let current_line = nextnonblank(current_line + 1)
    endwhile
  endif

  if current_line == 0
    let current_line = last_line
  endif

  call cursor(current_line, 0)
  execute 'normal zz'
endfunction
map gi :call GoToNextIndentBlock()<cr>

function! GoToPrevIndentBlock()
  let current_line = line('.')

  let target_indent = indent(current_line)
  let skip_second_loop = 0

  if target_indent == 0
    let skip_second_loop = 1
    let target_indent = 1
    let current_line = prevnonblank(current_line - 1)
  endif

  " Skip lines with the same or more indentation
  while (current_line > 1) && (target_indent <= indent(current_line))
    let current_line = prevnonblank(current_line - 1)
  endwhile

  if skip_second_loop == 0
    " Now go find first line with less indentation
    while (current_line > 1) && (target_indent > indent(current_line))
      let current_line = prevnonblank(current_line - 1)
    endwhile
  endif

  if current_line == 0
    let current_line = 1
  endif

  call cursor(current_line, 0)
  execute 'normal zz'
endfunction
map gI :call GoToPrevIndentBlock()<cr>

" ----------------------------------------------------------------------------
" Plugins
" ----------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'junegunn/vim-easy-align'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'pangloss/vim-javascript'
Plug 'michaeljsmith/vim-indent-object'
Plug 'godlygeek/tabular'
"Plug 'plasticboy/vim-markdown'
Plug 'preservim/vim-markdown'
Plug 'vim-ruby/vim-ruby'
Plug 'slim-template/vim-slim'
Plug 'rhysd/vim-clang-format'
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
" Plug 'w0rp/ale'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-python/python-syntax'

"Plug 'jacoborus/tender.vim' " Colorscheme
"Plug 'ayu-theme/ayu-vim'
Plug 'Luxed/ayu-vim'

call plug#end()

" ----------------------------------------------------------------------------
" Configure Plugins
" ----------------------------------------------------------------------------

" NERDTree

nmap <silent> <c-n> :NERDTreeToggle<CR>

"autocmd VimEnter * silent NERDTree | wincmd p

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 30
let NERDTreeIgnore=['\.sock$', '\.rdb$']

" FZF

nmap <silent> <leader>t :FZF<CR>
nmap <silent> <leader>b :Buffers<CR>
let g:fzf_layout = { 'down': '~20%' }
let $FZF_DEFAULT_OPTS = '--color fg+:reverse,hl:3,hl+:3:reverse'

" FZF hide terminal buffer statusline
autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Color
set termguicolors
"colorscheme tender-adjusted
let ayucolor="mirage"
colorscheme ayu

"let g:airline_theme = 'tender'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.dirty = '[*]'
let g:airline_symbols.colnr = ' :'
let g:airline_extensions = ['branch']
let g:airline#extensions#branch#displayed_head_limit = 10

xmap ga <Plug>(EasyAlign)
map ga <Plug>(EasyAlign)

" Instead of using this line:
" 
"   let g:clang_format#auto_format = 1
"
" We are just going to specify clang_format manually for c, cpp files only.
" Plugin unfortunately hardcodes all file types (encroaching on javascript, typescript).
autocmd BufWritePre *.c call clang_format#replace(1, line('$'))
autocmd BufWritePre *.cpp call clang_format#replace(1, line('$'))

" Rust

let g:rustfmt_autosave = 1
"let g:rustfmt_command = "cargo +nightly fmt --"
hi rustFuncName guifg=#FFD57F cterm=bold
hi rustSelf ctermfg=11 guifg=#FFAE57 cterm=bold,italic
hi rustAwait term=italic cterm=bold,italic ctermfg=13 gui=italic guifg=#D4BFFF
"hi! rustAwait cterm=bold,italic

" Coc Rust Analyzer

" Tab to trigger completion.
"autocmd FileType rust inoremap <silent><expr> <TAB>
"      \ coc#pum#visible() ? coc#pum#next(1):
"      \ CheckBackspace() ? "\<Tab>" :
"      \ coc#refresh()
"
"autocmd FileType rust inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
"inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"autocmd CursorHold *.rs silent call CocActionAsync('doHover')
"autocmd FileType rust nnoremap <silent> K :call CocActionAsync('doHover')<CR>
"nmap <leader>qf  <Plug>(coc-fix-current)

" Markdown

" Do not hightlight code snippets.
let g:vim_markdown_fenced_languages = []
hi def link mkdCode Comment

" Python

let g:python_highlight_all = 1
hi pythonFunction guifg=#FFD57F cterm=bold
hi pythonClass guifg=#FFC44C cterm=bold
hi pythonDecoratorName guifg=#FFD57F cterm=bold

" ----------------------------------------------------------------------------
" OS Specific Settings
" ----------------------------------------------------------------------------

source ~/.vimrc-os
