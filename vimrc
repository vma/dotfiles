colorscheme desert
filetype plugin indent on
syntax on

let mapleader = "\<space>"

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'bogado/file-line'
"Plug 'easymotion/vim-easymotion'
"Plug 'kana/vim-fakeclip'
"Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
"Plug 'AndrewRadev/splitjoin.vim'
"Plug 'SirVer/ultisnips'
call plug#end()

set updatetime=250              " update every 250ms
set backspace=indent,eol,start
set tabstop=4
set shiftwidth=4
set textwidth=0 wrapmargin=0
set laststatus=2                " always show status line
set nowrap
set wrapscan
set ignorecase
set shiftround
set expandtab
set vb
set t_vb=                       " no visual bell
set ch=1
set showmatch
set ruler
set bs=2
set background=dark
set list listchars=tab:>-,trail:.
set nocompatible
set autowrite                   " Write on :next/:prev/^Z
set showcmd
set lazyredraw
hi LineNr ctermfg=DarkGrey
set autoindent                  " Carry over indenting from previous line
set cindent                     " Automatic program indenting
set cinkeys-=0#                 " Comments don't fiddle with indenting
set cino=
set commentstring=\ \ #%s       " When folds are created, add them to this
set copyindent                  " Make autoindent use the same chars as prev line
silent! set foldmethod=marker   " Use braces by default
set noshowmode                  " Don't show mode line (redundant with lightline)

" Lightline
if !has('gui_running')
  set t_Co=256
endif
let g:lightline = {
\ 'colorscheme': 'Dracula',
\ 'active': {
\   'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'filename']],
\   'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding']]
\ },
\ 'component_function': {
\   'gitbranch': 'fugitive#head',
\   'filename': 'LightlineFilename',
\ },
\}

function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

" Don't scroll like crazy in the QuickFix and other fixes
autocmd FileType qf setlocal number nolist scrolloff=0
autocmd Filetype qf wincmd J

" Split to below and right
set splitbelow
set splitright

" Simpler mappings to switch between splits
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

" Search
set hlsearch            "Highlight all matched terms
set incsearch           "Incrementally highlight
hi Search cterm=NONE ctermfg=Black ctermbg=Green
nmap <Leader><space> :nohlsearch<CR>
map <C-\> <C-t>

" Fuzzy search
nmap <Leader>k :Ack! "\b<cword>\b"<CR>
nmap <Leader>g :Ggrep! "\b<cword>\b"<CR>

" Buffer, file & tag list
nmap ; :buffers<CR>
nmap <Leader>t :files<CR>
nmap <Leader>r :tags<CR>

" Quick fix window close
nnoremap \q :cclose<CR>

" Easy motion
let g:EasyMotion_do_mapping = 0     "Disable default mappings
let g:EasyMotion_smartcase = 1      "Turn on case insensitive feature
let g:EasyMotion_startofline = 0    "keep cursor column when JK motion

nmap <Leader>  <Plug>(easymotion-prefix)
nmap         s <Plug>(easymotion-overwin-f2)
nmap <Leader>l <Plug>(easymotion-lineforward)
"nmap <Leader>j <Plug>(easymotion-j)
"nmap <Leader>k <Plug>(easymotion-k)
nmap <Leader>h <Plug>(easymotion-linebackward)

" vim-gitgutter specific
set signcolumn=yes

" fakeclip specific
let g:fakeclip_provide_clipboard_key_mappings = 1
let g:fakeclip_terminal_multiplexer_type = 'tmux'
vmap <Leader>y <Plug>(fakeclip-screen-y)
vmap <Leader>Y <Plug>(fakeclip-screen-Y)
nmap <Leader>p <Plug>(fakeclip-screen-p)
nmap <Leader>P <Plug>(fakeclip-screen-P)

" vim-go specifics
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_auto_sameids = 0
let g:go_list_type = "quickfix"

"run :GoBuild or :GoTestCompile based on the go file
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
