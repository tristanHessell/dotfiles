" make vim not try to be comaptible with vi
set nocompatible
syntax on

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

augroup numbering_group
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * call SetNumbering()
  autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup end

function! SetNumbering () abort
  if &filetype !=# 'netrw' && &filetype !=# 'help'
    set relativenumber
  endif
endfunction

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

" show index of where the cursor is when searching
set shortmess-=S

" show command as typing it
set showcmd

" ask if we want to save if we try to quit with unsaved buffers
set confirm

" make colouring work better for dark screens
set background=dark

" make vim reload all buffers changed outside of vim
set autoread

" required so that Limelight can be used in a tty terminal
set t_Co=256

" turn built-in indent plugin on
filetype plugin indent on

set omnifunc=syntaxcomplete#Complete

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

augroup tidy_group
  autocmd!

  " define default (noop) Tidy command
  " setting the default Tidy command like this as
  " there were timing problems when using just `BufEnter *`
  let tidyFtToIgnore = ['json', 'html', 'javascript']

  autocmd BufEnter * if index(tidyFtToIgnore, &ft) < 0 | command! Tidy echo "Cannot tidy file of this type"

  " define Tidy command for json files (using jq)
  autocmd FileType json command! Tidy call <SID>tidyJson()

  " define Tidy command for html files (using HTML-Tidy)
  autocmd FileType html command! Tidy call <SID>tidyHtml()

  "define Tidy command for js files using ALE
  autocmd FileType javascript command! Tidy :ALEFix
augroup end

" make sure that that the background shown as selected when selecting
" characters in visual mode
highlight Visual cterm=reverse ctermbg=none

highlight MatchParen ctermfg=grey ctermbg=0

" set preview window at botom of screen
set splitbelow

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

" toggle the undotree with ,u
let g:undotree_WindowLayout = 2
nnoremap <LEADER>u :UndotreeToggle<CR> :UndotreeFocus<CR>

" show jump list with ,j
nnoremap <LEADER>j :jumps<CR>

function! Jsx (name)
  :-1read $HOME/.snippets/component.jsx
  :.,+11 s/COMPONENT/\=a:name/g
endfunction

" Jsx <component>: insert component snipped at cursor
command! -nargs=1 Jsx :call Jsx(<q-args>)

" Ren <filename>: rename buffer to filename
command! -nargs=1 -bang -complete=file Ren f <args>|w<bang>

" open up splits to the right of the current split
set splitright

" show netrw with no header, and in tree mode
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_fastbrowse = 0
" show netrw previews as a side split
let g:netrw_preview = 1
let g:netrw_alto = 0
let g:netrw_dirhistmax = 0

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
nnoremap <LEADER>b :call ToggleFileBrowser()<CR>

function! ToggleFileBrowser() abort
  if &filetype ==# 'netrw'
    :Rex
  else
    " if the current buffer has changes, dont leave the buffer
    " as netrw forgets them >:(
    if &mod ==# 1
      echo "Cannot show directory as buffer is unsaved"
    else
      :Ex
    endif
  endif
endfunction

" remove the netrw buffer otherwise its still there when
" you open vim with the session history (-S)
function! CheckNetrwBuffer() abort
  if &filetype ==# 'netrw'
    :bd
  endif
endfunction

augroup exit_group
  autocmd!
  autocmd ExitPre * call CheckNetrwBuffer()
augroup end

function! LeaveNetrwBuffer() abort
  if &filetype ==# 'netrw'
    :pclose
  endif
endfunction

augroup leave_netrw_group
  autocmd!
  autocmd BufHidden * call LeaveNetrwBuffer()
augroup end

function! SetCursorPos() abort
  let b:cursorPos = getpos('.')
endfunction
  
augroup leave_buffer
  autocmd!
  autocmd BufLeave * call SetCursorPos()
augroup end

function! GetCursorPos() abort
  " default to the top of the buffer
  " if you haven't opened it before
  let l:pos = get(b:, 'cursorPos', 0)
  call setpos('.', l:pos)
endfunction

augroup enter_buffer
  autocmd!
  autocmd BufEnter * call GetCursorPos()
augroup end

" make it so you can use ctrl-] to jump when NOT in a help file
" Its a lazy solution to the problem
augroup jump_group
  autocmd!
  autocmd FileType * nnoremap <buffer> <c-]> :LspDefinition<cr>
  autocmd FileType * nnoremap <buffer> <c-\> :LspReferences<cr>

" use the Lsp of the file to jump to the definition (instead of using tags)
  autocmd FileType help unmap <buffer> <c-]>
  autocmd FileType help unmap <buffer> <c-\>
augroup end

" this isnt the greatest key stroke, but vim isn't the best when it comes to key strokes. See https://stackoverflow.com/questions/18955798/using-ctrl-instead-of-esc-in-vim
nnoremap <c-p> :rightbelow LspDefinition<cr>

" Netrw TODO
" open netrw at the position of the buffer
" stop netrw from previewing a directory
" toggle preview open/close with 'p'
" make moving the line change the preview

set backspace=indent,eol,start

" toggle the quickfix list
command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction

nnoremap <LEADER>c :QFix<cr>

