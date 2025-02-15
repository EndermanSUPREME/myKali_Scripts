" Start plugin section
call plug#begin('~/.vim/plugged')

" Plugin list
Plug 'joshdick/onedark.vim'

" End plugin section
call plug#end()

syntax enable
set termguicolors
set background=dark
colorscheme onedark

set shiftwidth=4
set softtabstop=4
set expandtab
