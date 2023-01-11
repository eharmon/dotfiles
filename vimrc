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
  syntax on

  " Enable filetype detection plugins with all features
  filetype plugin indent on

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
set list
set listchars=tab:▸·,trail:·
set showbreak=↪

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
colo molokai

" Customize sign column colors
highlight SignColumn ctermbg=236 guibg=#303030

" Customize cursor line colors
highlight CursorLine cterm=NONE ctermbg=235 ctermfg=NONE guibg=#262626 guifg=NONE gui=NONE

" Enable 24-bit color and disable the background color (so transparency works)
" if we're not in tmux(meaning we won't potentially attach a different terminal
" later)
if ((empty($TMUX)))
  set termguicolors
  highlight Normal guibg=NONE

  " If we're in neovim and have iTerm2, switch the $TERM entry to support
  " advanced features. We can't just set that in the shell because most
  " systems have no terminfo entry for 'iterm2'.
  if (has('nvim') && $LC_TERMINAL == 'iTerm2')
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
if ((&term =~ '^screen') && ($VIM_PLEASE_SET_TITLE =~ '^yes$') || has('gui_running'))
  set t_ts=k
  set t_fs=\
  set title
  autocmd BufEnter * let &titlestring = "vim: " . expand("%:t")
  let &titleold = fnamemodify(&shell, ":t")
endif

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

