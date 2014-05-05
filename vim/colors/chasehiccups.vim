" .vim/colors/chasehiccups
"
" Use ':help highlight-groups' for syntax groups
" Use ':highlight' to list current colors set
" Use '\hlt' to find syntax-group of current word


" Set 'background' back to default.
hi clear Normal
set bg&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "chasehiccups"

" Support for 256-color terminal
if &t_Co > 255
  " Syntax highlighting
  hi Comment ctermfg=237
  hi Search ctermfg=011 ctermbg=NONE cterm=BOLD,UNDERLINE
  " General colors
  hi ColorColumn  cterm=NONE ctermbg=233 ctermfg=NONE
  hi CursorColumn cterm=NONE ctermbg=233 ctermfg=NONE
  hi CursorLine   cterm=NONE ctermbg=233 ctermfg=NONE
  hi Directory cterm=NONE ctermbg=NONE ctermfg=6
  hi Folded cterm=NONE ctermbg=NONE ctermfg=245
  hi LineNr cterm=NONE ctermbg=NONE ctermfg=237
  hi NonText cterm=NONE ctermbg=NONE ctermfg=232
  hi Normal cterm=NONE ctermbg=NONE ctermfg=252
  hi Pmenu cterm=NONE ctermbg=234 ctermfg=5
  hi PmenuSel cterm=NONE ctermbg=232 ctermfg=7
  hi PMenuSbar cterm=NONE ctermbg=232
  hi PMenuThumb cterm=NONE ctermbg=245
  hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=237
  hi StatusLine cterm=NONE ctermbg=234 ctermfg=245
  hi StatusLineNC cterm=NONE ctermbg=234 ctermfg=234
  hi VertSplit cterm=NONE ctermbg=NONE ctermfg=234
  hi Visual cterm=NONE ctermbg=238
  " Define custom highlight groups
  hi User1  cterm=NONE ctermbg=234 ctermfg=red
end
