" Vim settings
set ruler
set cursorline
set number
set noautoindent
set nohls
set tabstop=2 shiftwidth=2 expandtab

" Install pathogen
call pathogen#infect()

" Options
syntax on
syntax enable
filetype plugin indent on

" Solarized stuff
let g:solarized_termtrans = 1
set background=dark
colorscheme dracula
