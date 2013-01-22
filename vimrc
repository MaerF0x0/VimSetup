"syntax hilighting? yes please
syntax enable
set nocompatible

" I prefer 1 "tab" per line
set shiftwidth=4
" I prefer 4 space per tab
set tabstop=4
set softtabstop=4
set expandtab
" set smarttab
set backspace=start,indent

" I dont like wrapped text
set nowrap

" override spaces for ruby files:
autocmd Filetype ruby set local ts=2 sts=2 sw=2

" I dont like swap files
set noswapfile

" Make searches goto the middle of the screen.
nnoremap n nzzzv
nnoremap N Nzzzv

" Some alternate listchars
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮

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

set directory=~/.vim/swap
au BufRead,BufNewFile *.svn-base set filetype=php
au BufRead,BufNewFile *.php set filetype=php
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

filetype indent off
filetype on

set fo+=r       " formatoptions r adds new comment line automagically

" ok now for some cool stuff
:autocmd FileType php noremap pl :!/usr/bin/php -l %<CR>

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

" insert a php doc block
map pd :call PhpDocSingle()<CR>
" auto insert a require_once
map ro lbveyOp0k:s/_/\//girequire_once 'A.php';==

function! ZendFileName(fname)
    let l:newname = substitute(a:fname, '_', '\/', 'g') . '.php'
    return l:newname
endfunction


" C-l will show numbers
map <C-l> :set invnu<CR>
" set cntrl-u to uncomment (PHP)  a line and keep the whitespace
map <C-u> :s/^\(\s*\)\/\/\(\s*\)/\1\2/<Enter>

set path+=~/code/zend-current/library 
set path+=~/code/zend-current/application/library 
set suffixesadd=.php
set includeexpr=ZendFileName(v:fname)

set hlsearch

" Highlight variables under cursor
:autocmd CursorMoved * silent! exe printf('match IncSearch /\<%s\>/', expand('<cword>'))

" get log of highlighted lines (or current line)
vmap gl :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>
map <F1> <Esc>
imap <F1> <Esc> 

au BufNewFile,BufRead *.sms set filetype=phtml
au BufNewFile,BufRead *.email set filetype=phtml
au BufNewFile,BufRead *.push set filetype=phtml
au BufNewFile,BufRead *.fb set filetype=phtml
au BufNewFile,BufRead *.tw set filetype=phtml

