" manage plugins with Plug
" curl -fLo ~/.nvim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin('~/.nvim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'https://github.com/gregsexton/gitv.git'
Plug 'kien/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'junegunn/vim-easy-align'
Plug 'mtth/scratch.vim'
Plug 'saltstack/salt-vim'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'https://github.com/int3/vim-extradite.git'

" themes
Plug 'https://github.com/tomasr/molokai.git'

call plug#end()
"
" ================ General Config ====================

set backspace=indent,eol,start " Allow backspace in insert mode
set esckeys                    " Function keys that start with an <Esc> are recognized in Insert mode
set gcr=a:blinkon0             " Disable cursor blink
set hidden                     " allows you to change buffers without saving
set history=1000               " Store lots of :cmdline history
set number                     " Line numbers are good
set ruler                      " Show the line and column number of the cursor position
set showcmd                    " Show (partial) command in status line.
set showmode                   " Show current mode down the bottom
set visualbell                 " Use visual bell instead of beeping
set mls=5                      " search first/last lines for modeline
set showmatch                  " When a bracket is inserted, briefly jump to the matching one.
set cursorline                 " Highlight the screen line of the cursor with CursorLine
set nostartofline              " Try to preserve column where cursor is positioned.
set ls=2                       " show a status line even when only one window is shown
set shm=at                     " short message
set ww=<,>,h,l                 " Allow specified keys that move the cursor left/right to move to the previous/next line when the cursor is on the first/last character in the line
set cpoptions=ces$             " show $ at end of word when you use cw
set nopaste                    " default to no paste mode
set nodigraph                  " Disable the entering of digraphs in Insert mode with {char1} <BS>
set ignorecase                 " make searches case insensitive
set smartcase                  " if one or more chars is upper case, make the search case sensitive
set textwidth=79
set formatoptions=qrn1
set lazyredraw                 " When this option is set, the screen will not be redrawn while executing macros, registers and other commands that have not been typed.  Also, updating the window title is postponed.  To force an update use |:redraw|.

" ================ Search Settings  =================

set incsearch        "Find the next match as we type the search
set hlsearch         "Hilight searches by default
set viminfo='100,f1  "Save up to 100 marks, enable capital marks
"set viminfo=%,'50,\"100,:100,n~/.viminfo

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" =======Indentation ===========
set autoindent "Copy indent from current line when starting a new line
set smartindent
set smarttab "when we autoindent, backspace will delete the entire tab width, not just individual spaces

set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set wrap         "wrap lines
set linebreak    "Wrap lines at convenient points


" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest         " When more than one match, list all matches and complete first match.

set wildmenu                      " enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~       " stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" =============== Navigation ========================

" disable arrow keys for navigation
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk


"
" ctrlp
if exists(":CtrlP")
  let g:ctrlp_max_files = 0
  let g:ctrlp_open_new_file = 'r'
  let g:ctrlp_open_multiple_files = 'i'
  let g:ctrlp_show_hidden = 0
  let g:ctrlp_arg_map = 1
  "noremap <leader>b :CtrlPBuffer<CR>
endif

" ============== Custom Mappings ==============
nnoremap <leader><space> :noh<cr>
nnoremap <leader><leader> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" ============= AutoCmd ======================
if has("autocmd")
    augroup content
        autocmd!

        autocmd BufNewFile *.rb 0put ='# vim: set sw=4 ts=4 et :' |
                    \ 0put ='#!/usr/bin/env ruby' | set sw=4 ts=4 et |
                    \ norm G

        autocmd BufNewFile *.lua 0put ='# vim: set sw=4 ts=4 et :' |
                    \ 0put ='#!/usr/bin/env lua' | set sw=4 ts=4 et |
                    \ norm G

        autocmd BufNewFile *.hh 0put ='/* vim: set sw=4 ts=4 et foldmethod=syntax : */' |
                    \ 1put ='' | call MakeIncludeGuards() |
                    \ set sw=4 ts=4 et | norm G

        autocmd BufNewFile *.cc 0put ='/* vim: set sw=4 ts=4 et foldmethod=syntax : */' |
                    \ 1put ='' | 2put ='' | call setline(3, '#include "' .
                    \ substitute(expand("%:t"), ".cc$", ".hh", "") . '"') |
                    \ set sw=4 ts=4 et | norm G

        autocmd BufNewFile *.py 0put ='# vim set sw=4 ts=4 et :' |
                    \ 0put ='#!/usr/bin/env python' | set sw=4 ts=4 et |
                    \ norm G
"        autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,with,try,except,finally,def,class

        autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>
        au! BufRead,BufNewFile *.mkd   setfiletype mkd

        "ruby
        autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
        autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
        autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
        autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
        autocmd FileType mail set tw=72 "usefull for Mutt
        autocmd Filetype python let python_highlight_all=1
        autocmd Filetype python set nocindent
        " Execute file being edited with <Shift> + e:
        autocmd Filetype python map <buffer> <S-e> :w<CR>:!/usr/bin/env python % <CR>
        autocmd BufRead,BufNewFile *.js set ft=javascript.jquery
        autocmd BufRead,BufNewFile *.js.haml set ft=javascript.jquery
        autocmd BufRead,BufNewFile *.js.erb set ft=javascript.jquery
        autocmd BufRead,BufNewFile *.pp set ft=puppet
        autocmd Bufread,BufNewFile Makefile* set noexpandtab
        " Display tabs at the beginning of a line in Python mode as bad.
        autocmd BufRead,BufNewFile *.py,*.pyw match ExtraWhitespace /^\t\+/
        " Make trailing whitespace be flagged as bad.
        autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h match ExtraWhitespace /\s\+$/

    augroup END
    " Source the vimrc file after saving it. This way, you don't have to reload Vim to see the changes.
     augroup myvimrchooks
      au!
      autocmd bufwritepost .vimrc source %
     augroup END
endif
