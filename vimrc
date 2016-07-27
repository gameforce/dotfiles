" Vim settings
set ruler
set cursorline
set number
set noautoindent
set nohls

" Install pathogen
call pathogen#infect()

" Options
syntax on
filetype plugin indent on
syntax enable

" Solarized stuff
let g:solarized_termtrans = 1
set background=dark
colorscheme elflord
