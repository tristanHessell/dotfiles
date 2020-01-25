let mapleader = ","

set ts=3 " defines the width of tab characters in a file
set sts=2 " defines the width of a tab you enter
set et " expand tabs to spaces
set shiftwidth=2

" make fzf available to vim
set rtp+=~/.fzf

" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" load all the plugins now - need them loaded before helptags can be generated
packloadall

" generate the help tags
silent! helptags ALL

" use eslint for javascript linting 
let g:ale_fixers = { 'javascript': ['eslint'] }
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_delay = 1000

" indent the way I want
set autoindent
set smartindent

" show line numbers
set number relativenumber
autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber

" keep swapfiles in a central location
set directory^=$HOME/.vim/swap//

" turn off arrow keys in normal mode
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" turn off arrow keys in insert mode
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

" persist undo history of files
set undodir=~/.vim/undo
set undofile

" make sure there is no delay for escaping from visual mode
set timeoutlen=1000 ttimeoutlen=0

" use system clipboard
set clipboard=unnamedplus,unnamed

" always say how many lines have been yanked
set report=0

" no swapfiles
set nobackup noswapfile

" make vim write to the screen faster
set ttyfast

" always show the status-line
set laststatus=2

" STATUS LINE
set statusline=
" [buffer number]
set statusline+=[%n]
set statusline+=\  
" relative path to file
set statusline+=\ %f
" whether buffer is a help file
set statusline+=%h
" whether the buffer is modified
set statusline+=%m
" line number:column number
set statusline+=\ %l:%c
" shows if the session is being recorded ([$]) or not (nothing)
set statusline+=\ %{ObsessionStatus('[$]','')}
" END STATUS LINE

" show command as typing it
set showcmd

" use ctrl + p to bring up fuzzy finder
" nnoremap <C-P> :Files<CR>

" use ; to bring up buffers 
nmap ; :Buffers<CR>

" use leader t to bring up files
nmap <Leader>t :Files<CR>

" ask if we want to save if we try to quit with unsaved buffers
set confirm

" make sure that the file has a newline on save
function! AddLastLine()
  if getline('$') !~ "^$"
    call append(line('$'), '')
  endif
endfunction

" turned this off as it was messing around with some dev work
" autocmd BufWritePre * call AddLastLine()

" make colouring work better for dark screens
set background=dark

" make vim reload all buffers changed outside of vim
set autoread

" update Rg to show a preview
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" required so that Limelight can be used in a tty terminal
set t_Co=256

" close vim if NERDTREE is the only buffer open
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" turn built-in indent plugin on
filetype plugin indent on

function! s:tidyJson()
  let returnVal = system("jq . " . expand('%'))

  if v:shell_error == 0
    %!jq . 
  else
    echo "Cannot tidy file - invalid JSON file: " . v:shell_error
  endif
endfunction

function! s:tidyHtml()
  let return = system("tidy -i -q " . expand('%'))

  if v:shell_error == 0
    %!tidy -i -q
  else
    echo "Cannot tidy file - invalid Html file: " . v:shell_error
  endif
endfunction

" define default (noop) Tidy command
" setting the default Tidy command like this as
" there were timing problems when using just `BufEnter *`
let tidyFtToIgnore = ['json', 'html']
autocmd BufEnter * if index(tidyFtToIgnore, &ft) < 0 | command! Tidy echo "Cannot tidy file of this type"

" define Tidy command for json files (using jq)
autocmd FileType json command! Tidy call <SID>tidyJson()

" define Tidy command for html files (using HTML-Tidy)
autocmd FileType html command! Tidy call <SID>tidyHtml()

" make sure that that the background shown as selected when selecting
" characters in visual mode
highlight Visual cterm=reverse ctermbg=NONE

