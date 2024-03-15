"""" Determine if we're running on old unix

if has("unix")
  let s:old_unix = $OLD_UNIX
else

"""" Neovim

" Highlight when something is yanked
if has('nvim')
  au TextYankPost * silent! lua vim.highlight.on_yank()
endif

"""" Vim

" Configure vim to match neovim defaults that we want everywhere
if !has('nvim')
  " Auto indent
  set autoindent
  " Dark background
  set background=dark
  " Highlight searches
  set hlsearch
  " Search character at a time
  set incsearch
  " Always show status
  set laststatus=2
  " Turn on mouse support
  set mouse=nvi
  " Switch off compatible mode
  set nocompatible
  " Always show the cursor position (overridden by powerline)
  "set ruler
  " Fast ttys
  set ttyfast
  " Wild mode is magical
  set wildmenu

  " Turn on syntax highlighting
  if !exists("s:old_unix")
    syntax on
  endif

  " Enable filetype detection plugins with all features
  filetype plugin indent on

  " Send cursor shape escape sequences for iTerm2
  if ($LC_TERMINAL == 'iTerm2')
    let &t_SI = "\<Esc>]1337;CursorShape=1\x7"
    let &t_EI = "\<Esc>]1337;CursorShape=0\x7"
  endif
  " And for tmux
  if (!empty($TMUX))
    let &t_SI = "\<Esc>[6 q"
    let &t_EI = "\<Esc>[0 q"
  endif

  " Support standard title escapes. In tmux this only works to set the window
  " name, setting the terminal title would require 't_ts=^[]0;' but would
  " break the window name, which seems more valuable.
  set t_ts=k
  set t_fs=\

  " Cache things to our homedir, not random places
  if isdirectory(expand('~/.cache/vim'))
    set directory=~/.cache/vim/swap//,/tmp
    set backupdir=~/.cache/vim/backup//,/tmp
    if has('persistent_undo')
      set undodir=~/.cache/vim/undo//,/tmp
      set undofile
    endif
  endif
endif

"""" UI

" No intro message
set shortmess+=I

" Show matching parens
set showmatch
" Statusline configuration (overridden by powerline)
"set statusline=%f\ %y%m%r%=%c\,%l/%L\ (%p%%)

" Highlight current line
set cursorline

" Show some control chars
if !exists("s:old_unix")
  set list
  set listchars=tab:▸·,trail:·
  set showbreak=↪
endif

" Configure wildmode
set wildchar=<TAB>
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

" Always show a context line with the cursor
set scrolloff=1

" Completion
"set completeopt=longest,menuone,preview

"""" Colors

" Use peaksea colors
silent! colo molokai

" Customize sign column colors
highlight SignColumn ctermbg=236 guibg=#303030

" Customize cursor line colors
highlight CursorLine cterm=NONE ctermbg=235 ctermfg=NONE guibg=#262626 guifg=NONE gui=NONE

" Disable the background color since we always use a dark terminal
highlight Normal guibg=NONE ctermbg=NONE

" Enable 24-bit color if we're not in tmux (meaning we won't potentially attach a
" different terminal later)
if ((empty($TMUX)))
  if v:version > 800
    set termguicolors
  endif

  " If we're in neovim and using iTerm2 over SSH, switch the $TERM entry to
  " support advanced features. This will cause neovim to use it's internal
  " terminfo. When using iTerm2 locally (no ssh), it will set $TERMINFO_DIRS
  " to augment the xterm-256color entry instead, which is cleaner because
  " it'll be in sync with the latest iTerm2 features running locally.
  if (has('nvim') && !empty($SSH_TTY) && $LC_TERMINAL == 'iTerm2')
    let $TERM='iterm2'
  endif
endif

"""" Keyboard

let mapleader = ','
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>g :GitGutterToggle<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"""" Titles

" Set title string to the filename opened
set title
autocmd BufEnter * let &titlestring = "vim: " . expand("%:t")
let &titleold = fnamemodify(&shell, ":t")

"""" Airline

let g:airline_theme = 'powerlineish'
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#ale#enabled = 1

" If we're in iTerm2, but outside tmux and ssh, we know we have powerline fonts avail
" This is being set for us in the shell, but for reference: if (($LC_TERMINAL == 'iTerm2') && (empty($TMUX)) && (empty($SSH_TTY)))
if (($RICH_PROMPT_SUPPORTED == 1))
  let g:airline_powerline_fonts = 1
else
  let g:airline_left_sep = ''
  let g:airline_right_sep = ''
endif

" Airline related, we don't need to show the mode at the bottom since airline
" is already doing it for us
set noshowmode

"""" Gitgutter

highlight GitGutterAdd cterm=bold ctermfg=119 ctermbg=236 guifg=#87ff5f guibg=#303030
highlight GitGutterDelete cterm=bold ctermfg=167 ctermbg=236 guifg=#df5f5f guibg=#303030
highlight GitGutterChange cterm=bold ctermfg=227 ctermbg=236 guifg=#ffff5f guibg=#303030
" Also change the updatetime to make it update 'nearly' realtime
set updatetime=1500

"""" Vim Indent Guides

let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=236 guibg=#303030
hi IndentGuidesEven ctermbg=238 guibg=#444444

"""" Silver Searcher

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

