" Switch off compatible mode
set nocompatible
" No intro message
set shortmess+=I
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

" Sign column settings
highlight SignColumn ctermbg=236

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

" Always show a context line with the cursor
set scrolloff=1

" Cache things to our homedir, not random places
if isdirectory(expand('~/.cache/vim'))
  set directory=~/.cache/vim/swap//,/tmp
  set backupdir=~/.cache/vim/backup//,/tmp
  if has('persistent_undo')
    set undodir=~/.cache/vim/undo//,/tmp
    set undofile
  endif
endif

" Set title string to the filename opened
if ((&term =~ '^screen') && ($VIM_PLEASE_SET_TITLE =~ '^yes$') || has('gui_running'))
  set t_ts=k
  set t_fs=\
  set title
  autocmd BufEnter * let &titlestring = "vim: " . expand("%:t")
  let &titleold = fnamemodify(&shell, ":t")
endif

" Airline options
let g:airline_theme = 'powerlineish'
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#ale#enabled = 1

" If we're in iTerm2, but outside tmux and ssh, we know we have powerline fonts avail
if (($LC_TERMINAL == 'iTerm2') && (empty($TMUX)) && (empty($SSH_TTY)))
  let g:airline_powerline_fonts = 1
else
  let g:airline_left_sep = ''
  let g:airline_right_sep = ''
endif

" Airline related, we don't need to show the mode at the bottom since airline
" is already doing it for us
set noshowmode

" GitGutter options
highlight GitGutterAdd cterm=bold ctermfg=119 ctermbg=236
highlight GitGutterDelete cterm=bold ctermfg=167 ctermbg=236
highlight GitGutterChange cterm=bold ctermfg=227 ctermbg=236
" Also change the updatetime to make it update 'nearly' realtime
set updatetime=1500

" vim-indent-guides options
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=236
hi IndentGuidesEven ctermbg=238

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Keyboard shortcuts
let mapleader = ','
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>g :GitGutterToggle<CR>:SignifyToggle<CR>
nnoremap <leader>s :SyntasticCheck<CR>
nnoremap <leader>p :CtrlP<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
