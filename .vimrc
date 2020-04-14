" make vim not try to be comaptible with vi
set nocompatible

" make vim not interpet modelines (text in a file that can be used to
" configure vim)"
set nomodeline

let mapleader = ","

set ts=3 " defines the width of tab characters in a file
set sts=2 " defines the width of a tab you enter
set et " expand tabs to spaces
set shiftwidth=2

let g:highlightedyank_highlight_duration = 500

" only set the fzf stuff if we have fzf
if executable("fzf")
  " make fzf available to vim
  " .fzf is required if the package was downloaded through git
  " such as if you are on a version of ubuntu that doesnt have it
  " accessible through apt
  if !empty(glob("~/.fzf"))
    set rtp+=~/.fzf
  else
    set rtp+=/usr/bin/fzf
  endif

  if !empty(glob("/usr/share/doc/fzf/examples/fzf.vim"))
    source /usr/share/doc/fzf/examples/fzf.vim
  endif

  " update Rg to show a preview
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --hidden --follow --column --line-number --no-heading --color=always --smart-case '.shellescape(<Q-ARGS>), 1,
    \   fzf#vim#with_preview(), <BANG>0)

  " use ; to bring up buffers 
  nmap ; :Buffers<CR>

  " use leader f to bring up files
  nmap <LEADER>f :Files<CR>

  " use leader m to bring up marks
  nmap <LEADER>m :Marks<CR>

else
  nmap ; :buffers<CR>
  nmap <LEADER>m :marks<CR>
endif

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
autocmd BufEnter,FocusGained,InsertLeave :call SetNumbering()<CR>
autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber

function! SetNumbering () abort
  if &filetype !=# 'netrw' || &filetype !=# 'help'
    set relativenumber
  endif
endfunction

" keep swapfiles in a central location
" commented out as we dont use swap files at all
" set directory^=$HOME/.vim/swap//

" turn off arrow keys in normal mode
noremap <UP> <NOP>
noremap <DOWN> <NOP>
noremap <LEFT> <NOP>
noremap <RIGHT> <NOP>

" turn off arrow keys in insert mode
inoremap <UP> <NOP>
inoremap <DOWN> <NOP>
inoremap <LEFT> <NOP>
inoremap <RIGHT> <NOP>

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

" , C: toggle a column under the cursor (does not work in tty)
" this column moves with the cursor
nnoremap <LEADER>C :set cursorcolumn!<CR>

" set preview window at botom of screen
set splitbelow

" no-op backspace and delete in insert mode
" (i will probably add these back in - i am just using them temporarily so i
" learn to code in vim while using the correct motions)
" inoremap <BS> <NOP>
" inoremap <DEL> <NOP>

" make it possible to show whitespace and use different characters for it
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·
highlight SpecialKey ctermfg=darkblue guifg=darkblue
highlight NonText ctermfg=darkblue guifg=darkblue

" , w: toggle showing the *w*hitespace characters 
nnoremap <LEADER>w :set list!<CR>

" highlight all search matches
set hlsearch

" pressing return (only) in normal mode gets rid of search highlighting
nnoremap <SPACE> :nohlsearch<CR>

" highlight matches as you are typing your searches
set incsearch

nnoremap <LEADER>c :execute "set colorcolumn=" . (&colorcolumn == "" ? col('.') : "")<CR>

" toggle the undotree with ,u
let g:undotree_WindowLayout = 2
nnoremap <LEADER>u :UndotreeToggle<CR> :UndotreeFocus<CR>

" show jump list with ,j
nnoremap <LEADER>j :jumps<CR>

nnoremap <LEADER>jsx :-1read $HOME/.snippets/component.jsx<CR>:%s/COMPONENT/
" TODO make this take input for the component name and then go to the render
" body

" open up splits to the right of the current split
set splitright

" show netrw with no header, and in tree mode
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_fastbrowse = 0

" make searching case insensitive when no capitals are in string, case
" sensitive when they contain capitals
set smartcase
set ignorecase

" F**k ex mode!
nmap Q <NOP>

" show the wildmenu, allowing you to cleanly tab complete filenames/commands
" etc
if has("wildmenu")
  set wildmenu
  set wildmode=longest:list
endif

" ignore case sensitivity for filename completion
if exists("&wildignorecase")
  set wildignorecase
endif

" dont open up help with F1
nnoremap <F1> <NOP>
" dont try to man the current word with K
nnoremap K <NOP>

" make Y work like D and C - from the cursor to the end of the line
nnoremap Y y$

" ,b will open the file explorer
nnoremap <LEADER>b :Rexplore<CR>

