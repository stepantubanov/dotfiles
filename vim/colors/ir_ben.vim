set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "ir_ben"

" Change 075 => blue

"hi Example          ctermfg=NONE        ctermbg=NONE        cterm=NONE

" General colors
hi Normal            ctermfg=NONE        ctermbg=NONE         cterm=NONE "guibg=#333333
hi NonText           ctermfg=237         ctermbg=NONE        cterm=NONE

hi Cursor            ctermfg=black       ctermbg=white       cterm=reverse
hi LineNr            ctermfg=darkgray    ctermbg=NONE         cterm=NONE

hi VertSplit         ctermfg=darkgrey    ctermbg=darkgrey    cterm=NONE
hi StatusLine        ctermfg=white       ctermbg=darkgrey       cterm=NONE
hi StatusLineNC      ctermfg=darkgray    ctermbg=darkgrey       cterm=NONE

hi Folded            ctermfg=NONE        ctermbg=NONE        cterm=NONE
hi Title             ctermfg=NONE        ctermbg=NONE        cterm=NONE
hi Visual            ctermfg=NONE        ctermbg=239         cterm=NONE

hi SpecialKey        ctermfg=NONE        ctermbg=NONE        cterm=NONE

hi WildMenu          ctermfg=black       ctermbg=yellow      cterm=NONE
hi PmenuSbar         ctermfg=black       ctermbg=white       cterm=NONE

hi Error             ctermfg=white       ctermbg=red         cterm=NONE
hi ErrorMsg          ctermfg=white       ctermbg=red         cterm=NONE
hi WarningMsg        ctermfg=white       ctermbg=red         cterm=NONE

" Message displayed
hi ModeMsg           ctermfg=green       ctermbg=NONE        cterm=bold

if version >= 700
  hi CursorLine      ctermfg=NONE        ctermbg=236       cterm=NONE
  hi CursorColumn    ctermfg=NONE        ctermbg=NONE        cterm=BOLD
  hi MatchParen      ctermfg=white       ctermbg=darkgray    cterm=NONE
  "hi Pmenu           ctermfg=NONE        ctermbg=darkgray    cterm=NONE
  "hi PmenuSel        ctermfg=darkgray    ctermbg=81          cterm=NONE
  hi Pmenu           ctermfg=NONE        ctermbg=239         cterm=NONE
  hi PmenuSel        ctermfg=18          ctermbg=81          cterm=BOLD
  hi Search          ctermfg=NONE        ctermbg=NONE        cterm=underline
endif

" Syntax highlightin
hi Comment           ctermfg=244    ctermbg=NONE        cterm=NONE
hi String            ctermfg=lightcyan       ctermbg=NONE        cterm=NONE
hi Number            ctermfg=magenta     ctermbg=NONE        cterm=NONE

hi Keyword           ctermfg=blue        ctermbg=NONE        cterm=NONE
hi PreProc           ctermfg=blue        ctermbg=NONE        cterm=NONE
hi Conditional       ctermfg=lightmagenta   ctermbg=NONE        cterm=NONE  " if else end

hi Todo              ctermfg=red         ctermbg=NONE        cterm=NONE
hi Constant          ctermfg=cyan        ctermbg=NONE        cterm=NONE

hi Identifier        ctermfg=green        ctermbg=NONE        cterm=NONE
hi Function          ctermfg=magenta       ctermbg=NONE        cterm=NONE
hi Type              ctermfg=lightmagenta      ctermbg=NONE        cterm=NONE
hi Statement         ctermfg=blue   ctermbg=NONE        cterm=NONE

hi Special           ctermfg=white       ctermbg=NONE        cterm=NONE
hi Delimiter         ctermfg=cyan        ctermbg=NONE        cterm=NONE
hi Operator          ctermfg=white       ctermbg=NONE        cterm=NONE

hi link Character       Constant
hi link Boolean         Constant
hi link Float           Number
hi link Repeat          Statement
hi link Label           Statement
hi link Exception       Statement
hi link Include         PreProc
hi link Define          PreProc
hi link Macro           PreProc
hi link PreCondit       PreProc
hi link StorageClass    Type
hi link Structure       Type
hi link Typedef         Type
hi link Tag             Special
hi link SpecialChar     Special
hi link SpecialComment  Special
hi link Debug           Special


" Special for Ruby
hi rubyRegexp                  guifg=#B18A3D      guibg=NONE      gui=NONE      ctermfg=brown          ctermbg=NONE      cterm=NONE
hi rubyRegexpDelimiter         guifg=#FF8000      guibg=NONE      gui=NONE      ctermfg=brown          ctermbg=NONE      cterm=NONE
hi rubyEscape                  guifg=white        guibg=NONE      gui=NONE      ctermfg=cyan           ctermbg=NONE      cterm=NONE
hi rubyInterpolationDelimiter  guifg=#00A0A0      guibg=NONE      gui=NONE      ctermfg=blue           ctermbg=NONE      cterm=NONE
hi rubyControl                 guifg=#6699CC      guibg=NONE      gui=NONE      ctermfg=blue           ctermbg=NONE      cterm=NONE  "and break, etc
hi rubyStringDelimiter         guifg=#336633      guibg=NONE      gui=NONE      ctermfg=lightgreen     ctermbg=NONE      cterm=NONE

hi link rubyClass             Keyword
hi link rubyModule            Keyword
hi link rubyKeyword           Keyword
hi link rubyOperator          Operator
hi link rubyIdentifier        Identifier
hi link rubyInstanceVariable  Identifier
hi link rubyGlobalVariable    Identifier
hi link rubyClassVariable     Identifier
hi link rubyConstant          Type

hi link rubyBlockParameter Identifier
hi link rubyResponse       Function
hi link rubyAssertion      Function
hi link rubyTestMacro      Function

" Special for XML
hi link xmlTag          Keyword
hi link xmlTagName      Conditional
hi link xmlEndTag       Identifier


" Special for HTML
hi link htmlTag         Keyword
hi link htmlTagName     Conditional
hi link htmlEndTag      Identifier


" Special for Javascript
hi link javaScriptNumber      Number


" Special for CSharp
hi  link csXmlTag             Keyword
