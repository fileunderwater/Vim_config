" _vimrc
" Contains general settings, key mappings, functions and stuff for specific programs
" and plugins
" to re-source:  source $MYVIMRC
" on unix/linux .vimrc is symlinked to this file.
 
"BASIC APPERANCE
"--------------------------------------------------------------
set nocompatible	"turn off vi legacy mode
colorscheme inkpot	"alt delek, morning
winpos 0 0
"au GUIEnter * simalt ~x "to get maximum window
set history=1500
set cmdheight=2
"source $VIMRUNTIME/vimrc_example.vim
let maplocalleader = '-' 

""set encoding options
setglobal nobomb
setglobal fileencodings=utf-8,usc-bom,latin1
setglobal encoding=utf-8

" set backup directory
cd $HOME/texttmp	"default directory for new files
set backupdir=$HOME\texttmp,.
set directory=$HOME\texttmp,.

"set win/unix options
if has("win32")
	set ffs=dos,unix
	set lines=70 columns=170
	set guifont=Consolas:h11::cANSI
else
	if has("unix")
		set ffs=unix,dos
		"set guifont=Monospace 10
	endif
endif


" Some Windows-like behaviour - from msvim.vim
"-------------------------------
"source $VIMRUNTIME/mswin.vim
"behave mswin

map <S-Insert>		"+gP	

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.
exe 'inoremap <script> <S-Insert>' paste#paste_cmd['i']
exe 'vnoremap <script> <S-Insert>' paste#paste_cmd['v']


" From vimrc_example.vim
" ------------------------------------------------
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
" Don't use Ex mode, use Q for formatting
map Q gq	
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
set autochdir
"----------------------------------------------

" use mouse is present
if has('mouse')
  set mouse=a
endif

""to turn of backups
"set nobackup

"viewing options
set incsearch	"incremental search
set hlsearch	"highlight search
"set ignorecase	"to use case-insensitive search
set showmatch
set number	"turn on line numbers
set splitright	"vertical split

"for coding
syntax enable
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on


" GENERAL MAPPINGS
" -----------------------------------------
noremap <C-s> i<CR><Esc>
noremap , :
imap ii <ESC>
vmap ii <ESC>
nmap '' `
map + $
command Spell :setlocal spell spelllang=en_us
nmap -n ]s
nmap -p [s
noremap <M-c> ~
"to replace word with yanked/cut text
nmap <silent> cp "_cw<C-R>"<Esc> 

" WRAPPING 
" -----------------------------------------
"option for wrapping words
set wrap linebreak
"set showbreak='...'

""set shortcuts for wrapped pages
nnoremap <C-j> gj
nnoremap <C-k> gk
"nmap <C-1> $
"vmap <D-4> g$
"vmap <D-6> g^
"vmap <D-0> g^
"nmap <D-j> gj
"nmap <D-k> gk
"nmap <D-4> g$
"nmap <D-6> g^
"nmap <D-0> g^

"" Nice wrapping behavior
"nnoremap j gj
"nnoremap k gk
"vnoremap j gj
"vnoremap k gk
"nnoremap gj
"nnoremap gk
"noremap gj
"vnoremap gk
"inoremap gj
"inoremap gk

"FOLDING
"---
autocmd Syntax tex,vim setlocal foldmethod=syntax
autocmd Syntax tex,vim normal zR
"set foldmethod=syntax
set foldlevel=20
set foldlevelstart=20


" PLUGINS
"------------------------------------------------------
" For Vim-R-plugin
let vimrplugin_assign = 0

"Omni-completion
"to turn on
filetype plugin on
set ofu=syntaxcomplete#Complete
"improve menu behaviour
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <C-Space> <C-X><C-O>


"Python stuff
"-----------------------------------------------------
"noremap <silent> <F5> <ESC>:!start "!python %"<CR> 
noremap <silent> <F5> <ESC>:w<CR>: execute "!python %"<CR><CR>
noremap <C-F5> <ESC>:w<CR>: execute "!c:/python32/python %"<CR><CR>
"noremap <F5> <ESC>:w<CR>:silent execute "!python %"<CR><CR>

"to fix remap conflict with imaps/latex-vim
nnoremap <SID><C-S-j> <Plug>IMAP_JumpForward

"to use spaces instead of tabs in python
autocmd FileType * set tabstop=2|set shiftwidth=2|set noexpandtab
autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType python set softtabstop=4 " makes the spaces feel like real tabs


" VIM_LATEX 
" ----------------------------------------------------
" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'


" MARKDOWN 
" -----------------------------------------------
" create a html document from markdown file
command Markdown ! perl "c:\Program Files (x86)\Markdown_1.0.1\Markdown.pl" --html4tags %:p > %:p:h/%:t:r.html
" add syntax file
au BufRead,BufNewFile *.text set filetype=mkd


" OTHER STUFF
" ---------------------------------------------------------
" Functions to switch between writing code and prose
function! Prose()
	nnoremap j gj
	nnoremap k gk
	vnoremap j gj
	vnoremap k gk
	"nnoremap gj
	"nnoremap gk
	"noremap gj
	"vnoremap gk
	"inoremap gj
	"inoremap gk
	nmap 0 g^
	nmap + g$
	"nmap $ g$
endfunction

function! Code()
	if strlen(maparg("+", "g$"))
		nunmap +
	endif
	map + $
	if strlen(maparg("0", "g^"))
		nunmap 0
	endif
	if strlen(maparg("j", "gj"))
		nunmap j
	endif
	if strlen(maparg("k", "gk"))
		nunmap k
	endif
endfunction

" Other functions - some not functional
function! Mark2html()
		:let p=expand("%:p:h")
		:let n=expand("%:t:r")
		:Markdown
		:vert split
		:exe "e" p."/".n.".html"
endfunction

function! Pandoc(type)
		"function not fully functional yet.
		let p=expand("%:p:h")
		let n=expand("%:t:r")
		let c=expand("%:p")
		let convtype=a:type
		exe  "! pandoc -f markdown -t" convtype c "-o" p."/".n.".tex"  
		vert split
		exe "e" p."/".n.".tex"
endfunction
