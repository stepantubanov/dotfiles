" ----------------------------------------------------------------------------
" Misc Editor
" ----------------------------------------------------------------------------

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

" ----------------------------------------------------------------------------
"  Text Formatting
" ----------------------------------------------------------------------------

set foldmethod=manual
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

" Quickly toggle between relative and absolute line numbers
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <C-l> :call NumberToggle()<Cr>

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

    let command = 'BUILD_TYPE=' . (a:debug ? 'Debug' : 'Release') . ' .vim/run'

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

    let command = "g++ -std=c++17 -O3 -ffast-math -march=native -g % -lm -lbenchmark -lpthread && ./a.out"

  elseif expanded_path =~ "\\.cpp$"

    let command = "g++ -std=c++17 -O3 -ffast-math -march=native -g % && time ./a.out"

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
Plug 'plasticboy/vim-markdown'
Plug 'vim-ruby/vim-ruby'
Plug 'slim-template/vim-slim'
Plug 'rhysd/vim-clang-format'

Plug 'jacoborus/tender.vim' " Colorscheme

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

map <leader>t :FZF<CR>
map <leader>b :Buffers<CR>
let g:fzf_layout = { 'down': '~20%' }

" Color
set termguicolors
colorscheme tender-adjusted

let g:airline_theme = 'tender'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.dirty = '[*]'
let g:airline_extensions = ['branch']

xmap ga <Plug>(EasyAlign)
map ga <Plug>(EasyAlign)

let g:clang_format#auto_format = 1

" ----------------------------------------------------------------------------
" OS Specific Settings
" ----------------------------------------------------------------------------

source ~/.vimrc-os
