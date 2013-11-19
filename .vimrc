"
" Useful commands
" ,/			: clears my search results
" :oldfiles OR :browse oldfiles
" DiffOrig: shows differences between current version of file and original one
"
" TODO:
"		tabularize
"		tagbar
"		matchit

set backspace=indent,eol,start
set nocompatible

if has("vms")
	set nobackup
else
	set backup
	set backupdir=/tmp//
endif
set viewdir=/tmp//

set history=50
set ruler
set number
set showcmd
set incsearch
set cursorline

set wildmenu
set wildmode=list:longest,full

set nowrap

set cindent
set noexpandtab
set copyindent
"set preserveindent
set softtabstop=0
set shiftwidth=2
set tabstop=2
set shiftround
set showmatch
set smartcase
set showmode

set title
set novisualbell
set noerrorbells
set autowrite

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
noremap <silent> <F2> :set number!<CR>

map <F5> :make<CR>
nmap <silent> <F8> :TagbarToggle<CR>

if &wrap
	nnoremap <down> gj
	nnoremap <up> gk
endif

map <C-up> <C-Y>
map <C-down> <C-E>

nnoremap <A-down> :m .+1<CR>==
nnoremap <A-up> :m .-2<CR>==
inoremap <A-down> <Esc>:m .+1<CR>==gi
inoremap <A-up> <Esc>:m .-2<CR>==gi
vnoremap <A-down> :m '>+1<CR>gv=gv
vnoremap <A-up> :m '<-2<CR>gv=gv

nnoremap <silent> <A-left> :tabp<CR>
nnoremap <silent> <A-right> :tabn<CR>

imap <C-Space> <C-x><C-o>
imap <C-@> <C-Space>

if $COLORTERM == 'gnome-terminal'
	set t_Co=256
endif

if executable("/bin/bash")
	set shell=/bin/bash
elseif executable("/bin/sh")
	set shell=/bin/sh
endif

function CloseCPair()
	:inoremap ( ()<ESC>i
	:inoremap ) <c-r>=ClosePair(')')<CR>
	:inoremap { {}<ESC>i
	:inoremap } <c-r>=ClosePair('}')<CR>
	:inoremap [ []<ESC>i
	:inoremap ] <c-r>=ClosePair(']')<CR>
endf

function ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endf

if has("autocmd")
	filetype plugin indent on

	augroup vimrcEx
	au!


	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

	autocmd FileType xml setlocal equalprg="XMLLINT_INDENT=$'\t' xmllint --format --recover - 2>/dev/null"

	autocmd FileType python set omnifunc=pythoncomplete#Complete
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS
	autocmd FileType less set makeprg=lessc\ %
	autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
	autocmd FileType php set omnifunc=phpcomplete#CompletePHP
	autocmd FileType php set makeprg=php\ %
	autocmd FileType php let g:php_folding=2
	autocmd FileType php set foldmethod=syntax
	autocmd FileType c set omnifunc=ccomplete#Complete
	autocmd BufNewFile,BufRead *.di setfiletype d
	autocmd FileType d set foldmethod=syntax
	autocmd FileType d compiler dmd
	autocmd FileType d call CloseCPair()
	autocmd FileType d let s:tlist_def_d_settings = 'd;n:namespace;v:variable;d:macro;t:typedef;c:class;g:enum;s:struct;u:union;f:function'

	highlight ExtraWhitespace ctermbg=red guibg=red
	let s:matcher
				\ = 'match ExtraWhitespace /^\s* \s*\|\s\+$/'
	exec s:matcher

	autocmd BufWinEnter * exec s:matcher
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * exec s:matcher
	autocmd BufWinLeave * call clearmatches()

	autocmd BufWinLeave *.* mkview
	autocmd BufWinEnter *.* silent loadview

	autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

	if version >= 703
		autocmd InsertEnter * set relativenumber
		autocmd InsertLeave * set norelativenumber 
	endif

	autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
	autocmd InsertLeave * if pumvisible() == 0|pclose|endif

	augroup END
else
	set autoindent
endif


if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
	nmap <silent> ,/ :nohlsearch<CR>
	color jellybeans
endif

if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif

call pathogen#infect()

let g:easytags_suppress_ctags_warning = 1
let g:syntastic_mode_map = { 'mode': 'active',
	\ 'active_filetypes': ['d'],
	\ 'passive_filetypes': ['html'] }
let g:ctrlp_root_markers = ['src']
