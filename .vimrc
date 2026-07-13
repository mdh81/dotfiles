set number
set expandtab
set ts=4
set sw=4
syntax on
filetype plugin indent on
set cindent
map tn :tabnew <CR>
map tl :tabnext <CR>
map th :tabprev <CR>
map <C-n> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
iab pd 
\<CR>import pdb
\)<CR>pdb.set_trace()
set ruler
au BufNewFile,BufRead SCons* set filetype=scons
set backspace=indent,eol,start
map <C-t> :terminal <CR>
" Remove trailing white space in cpp files
autocmd bufwritepost *.h,*.cpp :silent! %s/\s\+$//e
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1

" latex
let g:vimtex_view_method = 'skim'

" gui
if has ('gui_running')
set guifont=Ayuthaya:h18
colorscheme monokai_pro
end 
