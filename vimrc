call pathogen#infect()
call pathogen#helptags()

set nocompatible
syntax enable
set nobackup
set noswapfile
filetype on
filetype indent plugin on
compiler ruby

set lazyredraw

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
"  Remapping
" ----------------------------------------------------------------------------

" lead with ,
let mapleader = ","

" exit to normal mode with 'jj'
inoremap jj <ESC>

" reflow paragraph with Q in normal and visual mode
"nnoremap Q gqap
"vnoremap Q gq

" Don't use arrows
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Quickly open and reload .vimrc
nmap <silent> <leader>ev :e $MYVIMRC<cr>
nmap <silent> <leader>sv :so $MYVIMRC<cr>

" Press F2, paste, press F2 again
set pastetoggle=<F2>

" Use ; instead of : to type commands
nnoremap ; :
vnoremap ; :

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
set number                 " line numbers
set wildmenu               " turn on wild menu
set wildmode=list:longest,full
set ch=2                   " command line height
set backspace=2            " allow backspacing over everything in insert mode
set whichwrap+=<,>,h,l,[,] " backspace and cursor keys wrap to
set report=0               " tell us about changes
set nostartofline          " don't jump to the start of line when scrolling


" ----------------------------------------------------------------------------
" Visual Cues
" ----------------------------------------------------------------------------
set cursorline             " highlight current line
set noshowmatch            " do not jump to the matching pair when typing
set mat=5                  " duration to show matching brace (1/10 sec)
set incsearch              " do incremental searching
set hlsearch               " highlight search results. Turn off highlighting with <leader>.
set laststatus=2           " always show the status line
set ignorecase             " ignore case when searching
set t_Co=256
set statusline=%f\ %m%y%=%c,%l/%L\ %P

"set synmaxcol=128
"syntax sync minlines=256

" show some special characters
set list listchars=tab:\ \ ,trail:·,nbsp:_,extends:»,precedes:«

set background=dark
colorscheme ir_ben

" ----------------------------------------------------------------------------
" AutoCommands
" ----------------------------------------------------------------------------

" Jump to last cursor position unless it's invalid or in an event handler (grb)
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion. (grb)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Running tests (grb)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>w :call RunTestFile()<cr>
map <leader>W :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
map <leader>c :w\|:!script/features<cr>
map <leader>C :w\|:!script/features --profile wip<cr>

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " Run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec\(.rb\|.coffee\|.js\)\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile()
" Set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  if match(a:filename, '\.feature$') != -1
    let run_tests_command = "script/features " . a:filename
  else
    if filereadable("script/test")
      let run_tests_command = "script/test " . a:filename
    elseif filereadable("bin/spring")
      let run_tests_command = "bin/spring rspec " . a:filename
    elseif filereadable("Gemfile")
      let run_tests_command = "bundle exec rspec " . a:filename
    else
      let run_tests_command = "rspec " . a:filename
    end
  end

  exec ":!clear && echo \"" . run_tests_command . "\" && " . run_tests_command
endfunction

" ----------------------------------------------------------------------------
" Rename file (grb)
" ----------------------------------------------------------------------------
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

"----------------------------------------------------------------------------
" Remove file
" ---------------------------------------------------------------------------
function! RemoveFile()
  call delete(expand('%'))
  call NERDTreeFocus()
  execute 'normal R'
endfunction
map <leader>d :call RemoveFile()<cr>

"-----------------------------------------------------------------------------
" Go to next indent block
" (goes to the next equally or less indented block)
"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
" Go to previous indent block
" (goes to the previous equally or less indented block)
"-----------------------------------------------------------------------------
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

nmap <silent> <c-n> :NERDTreeToggle<CR>

let g:showmarks_enable = 0

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 30

map <leader>T :CommandTFlush<cr>
let g:CommandTMaxHeight = 12
let g:CommandTMaxDepth = 10
let g:CommandTWildIgnore="*/tmp/*,*/public/assets,*/public/packs,*/public/packs-test,*/public/system,*/public/uploads,*/bower_components,*/node_modules,*/spec/vcr,*/vcr_cassettes,*/node_modules"

" set wildignore+=tmp/**,public/packs-test/**,public/packs/**,public/assets/**,public/system/**,public/uploads/**,,bower_components/**,node_modules/**,spec/vcr/**,spec/support/vcr_cassettes/**,client/node_modules/**,db/seeds/survey_templates.rb

let g:Powerline_colorscheme = 'default'
let g:Powerline_symbols = 'fancy'
set timeout timeoutlen=1000 ttimeoutlen=100

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Which syntax highlighting group is under the cursor
map <C-o> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
