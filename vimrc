set nocompatible
filetype off

"set the runtime path include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'


" Bundles go next
Bundle 'altercation/vim-colors-solarized'
Bundle 'fatih/vim-go'
Bundle 'plasticboy/vim-markdown'
"Bundle 'bling/vim-airline'
Bundle 'tpope/vim-fugitive'
"Bundle 'luochen1990/rainbow'
Bundle 'airblade/vim-gitgutter'
Bundle 'rking/ag.vim'
Bundle 'kchmck/vim-coffee-script'
"Python
Bundle 'pyflakes'
Bundle 'yssource/python.vim'
Bundle 'python_match.vim'
Bundle 'pythoncomplete'
Bundle 'vim-scripts/indentpython.vim'

"Thrift
Bundle 'solarnz/thrift.vim'

call vundle#end()

" Rest of VimRC now
syntax enable
filetype plugin indent on


" I prefer 1 "tab" per line
set shiftwidth=2
" I prefer 4 space per tab
set tabstop=2
set softtabstop=2
set expandtab

" I dont like wrapped text
set nowrap

"Set an 80 char width reminder
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
" I like line numbers and column numbers
set ruler

" I dont like swap files
set noswapfile

" Make searches goto the middle of the screen.
nnoremap n nzzzv
nnoremap N Nzzzv

" Some alternate listchars
set list listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L g_

" Make Comments Grey (for ease of reading on dark background
hi Comment ctermfg=darkgrey

highlight DiffAdd cterm=none ctermfg=gray ctermbg=darkblue
highlight DiffDelete cterm=none ctermfg=gray ctermbg=cyan
highlight DiffChange cterm=none ctermfg=green ctermbg=black
highlight DiffText cterm=none ctermfg=green ctermbg=darkgreen
highlight Directory cterm=none ctermfg=lightblue ctermbg=none

set t_Co=256
if &diff
    colorscheme slate2
else
    colorscheme molokai
endif
set backspace=start,indent,eol

" Use mouse
set mouse=a

" use wildmenu for file locating
set wildmenu

" searching
set incsearch
"" Ignore case when searching...
set ignorecase
"" ... unless i use case in my searches
set smartcase
"" ... but not for tab complete
set infercase

set fo+=r       " formatoptions r adds new comment line automagically

" Python PEP8 standard
" https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
au BufNewFile,BufRead *.py set tabstop=4 |set softtabstop=4 |set shiftwidth=4 |set textwidth=79 |set expandtab |set autoindent |set fileformat=unix


" Tab based autocomplete
function! InsertTabWrapper()
      let col = col('.') - 1
      if !col || getline('.')[col - 1] !~ '\k'
          return "\<tab>"
      else
          return "\<c-p>"
      endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" C-l will show numbers
map <C-l> :set invnu<CR>

set hlsearch

" Highlight variables under cursor
:autocmd CursorMoved * silent! exe printf('match IncSearch /\<%s\>/', expand('<cword>'))

" On my laptop I'm always hitting F1 instead of esc.. Really annoying to get
" into help views when i want to leave
map <F1> <Esc>
imap <F1> <Esc>

" jump to compiled version of line in CoffeeScript
command -nargs=1 C CoffeeCompile | :<args>
" I prefer vert splits
let coffee_watch_vert = 1
" I like line numbers
set number

" I want to reload external changes
set autoread

"the_silver_searcher for :grep
if executable('ag')
    " Note we extract the column as well as the file and line number
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m
endif

" Delete whitespaces on save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Go (golang) options
autocmd FileType go set nolist
let g:go_fmt_command = "goimports"

" Fold code based on syntax but only to 1 level
"set foldmethod=syntax
"set foldnestmax=2

" Save views for folding
"au BufWinLeave ?* mkview
"au BufWinEnter ?* silent loadview

autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufNewFile,BufRead *.es6    set filetype=javascript

