" _vimrc
" Contains general settings, key mappings and stuff for specifik programs
" and plugins
" use this to re-source:  source $MYVIMRC
 
"BASIC APPERANCE
"--------------------------------------------------------------
set nocompatible	"turn off vi legacy mode
colorscheme inkpot	"alt delek, morning
set guifont=Consolas:h11::cANSI
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

""set win/unix options
" set backup directory
if has("win32")
	cd c:\Users\tobjep\texttmp	"default directory for new files
	set backupdir=c:\Users\tobjep\texttmp,.
	set directory=c:\Users\tobjep\texttmp,.
	set ffs=dos,unix
	set lines=70 columns=170
else
	if has("unix")
		set backupdir=/home/tobias/tmp,.
		set directory=/home/tobias/tmp,.
		set ffs=unix,dos
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

" For Vim-R-plugin
let vimrplugin_assign = 0

"Omni-completion
"------------------------------------------------------
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
set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

""
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
	nmap 9 g$
	nmap $ g$
endfunction

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
