colorscheme desert
filetype plugin indent on
syntax on
execute pathogen#infect()

call plug#begin()
Plug 'AndrewRadev/splitjoin.vim'
Plug 'SirVer/ultisnips'
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

set tabstop=4
set shiftwidth=4
set textwidth=0 wrapmargin=0
set nowrap
set wrapscan
set ignorecase
set shiftround
set expandtab
set vb
set t_vb=   " no visual bell
set ch=1
set showmatch
set nohls
set ruler
set incsearch
set bs=2
set background=dark
set list listchars=tab:>-,trail:.
set nocompatible
set autowrite
set showcmd
set splitright
set splitbelow
set lazyredraw
set nu

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
highlight LineNr ctermfg=DarkGrey

let mapleader = "," 

" vim-go specifics
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1 
let g:go_highlight_build_constraints = 1 
let g:go_highlight_generate_tags = 1 
let g:go_auto_sameids = 0 
let g:go_list_type = "quickfix"

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <Leader>v <Plug>(go-def-vertical)
autocmd FileType go nmap <Leader>s <Plug>(go-def-split)
autocmd FileType go nmap <Leader>x <Plug>(go-doc-vertical)
autocmd FileType go nmap <Leader>i <Plug>(go-info)

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang As call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang Av call go#alternate#Switch(<bang>0, 'vsplit')
