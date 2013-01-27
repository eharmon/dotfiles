" Switch off compatible mode
set nocompatible
" Fast ttys
set ttyfast
" Turn on pathogen (add to runtime so we can leave it in a bundle and use it
" as a submodule)
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
filetype plugin indent on
" Turn on syntax highlighting
syntax on
"set t_Co=256
" Set the background to dark and turn on peaksea color scheme
set background=dark
colo peaksea
" Lightly color 80 lines, so we can remember the old days
if exists('+colorcolumn')
    set colorcolumn=81
    highlight ColorColumn ctermbg=235
endif
" Turn on mouse support
set mouse=a
" Always show the cursor position (overridden by powerline)
set ruler
" Show matching parens
set showmatch
" Auto indent
set autoindent
" Highlight searches
set hlsearch
" Search character at a time
set incsearch
" Statusline configuration (overridden by powerline)
set statusline=%f\ %y%m%r%=%c\,%l/%L\ (%p%%)
set laststatus=2
" Highlight current line
set cursorline
highlight CursorLine cterm=NONE ctermbg=black guibg=black
" Show some control chars
set list
set listchars=tab:▸·,trail:·
set showbreak=↪
" Wild mode is magical
set wildmenu
set wildchar=<TAB>
"set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit

set wildignore+=*.luac                           " Lua byte code

set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code

set wildignore+=*.orig                           " Merge resolution files
" Syntastic options (overridden by powerline)
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
let g:syntastic_check_on_open=1

" Sign column settings
highlight SignColumn ctermbg=235

" Completion
"set completeopt=longest,menuone,preview

" Resize splits when the window is resized
au VimResized * :wincmd =

" Only show cursorline in the current window and in normal mode.
augroup cline
    au!
    au WinLeave * set nocursorline
    au WinEnter * set cursorline
    au InsertEnter * set nocursorline
    au InsertLeave * set cursorline
augroup END

" Powerline settings
"let g:Powerline_symbols="unicode"

" Always show a context line with the cursor
set scrolloff=1

" Cache things to our homedir, not random places
if isdirectory(expand('~/.cache/vim'))
  if &directory =~# '^\.,'
    set directory^=~/.cache/vim/swap//
  endif
  if &backupdir =~# '^\.,'
    set backupdir^=~/.cache/vim/backup//
  endif
  if exists('+undodir') && &undodir =~# '^\.\%(,\|$\)'
    set undodir^=~/.cache/vim/undo//
  endif
endif
if exists('+undofile')
  set undofile
endif
