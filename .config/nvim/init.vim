""""""""""""""""""""
"  Enable Plugins  "
""""""""""""""""""""
filetype plugin indent on
filetype plugin on
runtime macros/matchit.vim

""""""""""
"  gVim  "
""""""""""
if has("gui_running")
	colo desert
	cd $HOME
else
	set background=dark
endif

""""""""""""""
"  Settings  "
""""""""""""""
set tw=99
set autoread
" Status Line Settings (mode display)
set nrformats+=alpha
set number
set laststatus=2
set clipboard=unnamedplus
set colorcolumn=100
set autoindent
set backspace=2
set tabstop=4
set shiftwidth=4
set expandtab
set nocompatible
" Allows Local .vimrc to be loaded
set exrc
set secure
" Enables Modeline Magic
set modeline
" Allows me to use the mouse
set mouse=a
" Allows me to highlight using a colon (:)
set iskeyword+=:
" Search Settings
set incsearch
set ignorecase
set smartcase
" Improves tab completion from normal mode
set wildmenu
set wildmode=full
" 'find'/ctrlp should ignore these folders
set wildignore+=*/__pycache__/*,*/.git/*,*/venv/*
" Increase command history limit
set history=200
" Always show one line above/below cursor
set scrolloff=1
" Allows you to change buffers without first saving the current buffer
set hidden
" Change default program for :grep to ack
set grepprg=ack\ --nogroup\ --column\ $*
set grepformat=%f:%l:%c:%m
" Autocompletion will only recommend completions that match the typed case
set infercase
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:␣
set nolist
set cursorline
set cursorcolumn
" Indents wraps
set breakindent
" Disables search highlighting
set nohlsearch
" Changes location of viminfo file
set viminfo+=n~/.vim/viminfo

""""""""""""""""""""""""""
"  Variable Assignments  "
""""""""""""""""""""""""""
" Appends the open file's directory to PATH
let tempPath=expand("%:p:h") . "/**"
exec "set path+=" . tempPath
" Sets LaTeX as default for .tex files
let g:tex_flavor = "latex"
" The <Leader> key can be used for extra mappings
let mapleader = ","
noremap \ ,
" Sets minimum size of active split (by percentage)
" let &winwidth = &columns * 6 / 10
let &winheight = &lines * 6 / 10

"""""""""""""""""""""""""
"  Syntax Highlighting  "
"""""""""""""""""""""""""
syntax on
syntax enable
set background=dark
" Enables syntax highlighting to work properly for certain filetypes
au BufRead,BufNewFile *.nasm set filetype=nasm
au BufRead,BufNewFile *.txt set filetype=txt
au BufRead,BufNewFile *.xmobarrc set syntax=haskell
au BufRead,BufNewFile *.lshrc set syntax=zsh
au BufRead,BufNewFile *.lzshrc set syntax=zsh
au BufRead,BufNewFile *.conf set syntax=cfg
" Used to make syntax highlighting more readable when using Linux
" transparent terminal
hi Constant ctermfg=lightmagenta 
hi SpellBad cterm=underline
hi Normal guibg=NONE ctermbg=NONE

""""""""""""""""""
"  Key Bindings  "
""""""""""""""""""
noremap <Leader>. :cd ..<CR>:call AddPWDtoPath()<CR>:pwd<CR>
" Shortcuts for quiting vim
noremap <Leader>e :quit<CR>
" Shortcuts for saving vim
noremap <Leader>s :w<CR>
" Makes ix.io snippet using highlighted text and sends ix.io link to clipboard
noremap <silent> <Leader>i :w !ix \| xargs printf "\%s/<C-R>=&filetype<CR>" \| xclip -sel clipboard<CR>
noremap <silent> <Leader><Leader>i :w !ix \| xclip -sel clipboard<CR>
" Preserves flags when repeating the last substitute command.
nnoremap & :&&<CR>
xnoremap & :&&<CR>
" Allows for visual search
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
" Allows space to work in Normal-Mode
nnoremap <space> i<space><esc>l
" Put space before and after character under cursor
nnoremap <Leader><space> a<space><esc>hi<space><esc>l
" NOTE:: Just use ZZ in normal mode to save and quit.
" Makes enter key work right in Normal mode
nnoremap <CR> o<Esc>
" Plugin Mappings
nmap <C-N> :cd %:h<CR>:NERDTree<CR><S-B>
nmap <Leader>p :CtrlPMRU<CR>
nmap <Leader>f :CtrlSF 
nmap <C-g> :Gstatus<CR>
" Swap highlighted word with last word in buffer
vnoremap <Leader>x <Esc>`.``gvP``P
nmap <Leader>x ve<Leader>x
" Will execute the 'Run' command which varies based on the file type
nmap <Leader>r :w<CR>:Run<CR>
imap <Leader>r <Esc><Leader>r
nmap <Leader>R :w<CR>:Run2<CR>
imap <Leader>R <Esc><Leader>R
" Improve up/down movement on wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
" Sets tmux pane to the current directory
nnoremap <Leader><F12> :call VimuxRunCommand("cd " .expand("%:p:h") ."&& clear")<CR>
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
" Used to recall commands from history
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" mapping to wrap paragraph
nnoremap <Leader>g gqap
" deletes current file and buffer
nnoremap <C-Del> :call delete(expand('%'))<CR>
nnoremap <C-s> :SyntasticToggleMode<CR>
" Edit Snippet File
nnoremap <Leader>S :e ~/.vim/bundle/vim-snippets/UltiSnips/<C-R>=&filetype<CR>.snippets<CR>
" Edit ftplugin File
nnoremap <Leader>F :e ~/.vim/ftplugin/<C-R>=&filetype<CR>.vim<CR>
" Delete Buffer
nnoremap <Leader>d :b#<bar>sp<bar>b#<bar>bd<CR>
" Vertical Buffer
nmap <Leader>v :vert sb
imap <Leader>v <Esc><Leader>v
" Omnicompletion shortcut
inoremap <C-o> <C-x><C-o>
" Toggles LiveDown for Markdown (e.g. README.md)
nmap <Leader>md :LivedownToggle<CR>
imap <C-h> <Esc><C-h>
imap <C-l> <Esc><C-l>
imap <C-j> <Esc><C-j>
imap <C-k> <Esc><C-k>
" bind <Leader>N to ':bN'
nmap <Leader>1 :b1<CR>
nmap <Leader>2 :b2<CR>
nmap <Leader>3 :b3<CR>
nmap <Leader>4 :b4<CR>
nmap <Leader>5 :b5<CR>
nmap <Leader>6 :b6<CR>
nmap <Leader>7 :b7<CR>
nmap <Leader>8 :b8<CR>
nmap <Leader>9 :b9<CR>
" cd to current working directory
nnoremap <Leader>0 :cd %:h<CR>:pwd<CR>
" fugitive mappings
nmap gd :Gdiff 
nmap gs :Gstatus<CR>

""""""""""""""""""""""""""""
"  Split and Tab Settings  "
""""""""""""""""""""""""""""
" See: http://www.codeography.com/2013/06/19/navigating-vim-and-tmux-splits "
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    silent! execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
      redraw!
    endif
  endfunction

  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif

""""""""""""""
"  AutoCmds  "
""""""""""""""
" Reloads buffer on buffer changes
autocmd FocusGained,BufEnter * :checktime
" Turns spellcheck on for certain file extensions
" 2nd line disables the colorcolumn
autocmd BufRead,BufNewFile *.txt set colorcolumn=
autocmd BufRead,BufNewFile *.md setlocal spell spelllang=en_us
autocmd BufRead,BufNewFile *.md set colorcolumn=
autocmd BufRead,BufNewFile *.html setlocal spell spelllang=en_us
autocmd BufRead,BufNewFile *.html set colorcolumn=
autocmd BufRead,BufNewFile *.tex setlocal spell spelllang=en_us
autocmd FileType mail setlocal spell spelllang=en_us
autocmd ColorScheme * highlight RedundantSpaces ctermbg=red
" Automatic rewriting of .vimrc
 autocmd! bufwritepost .vimrc source %
" http://stackoverflow.com/questions/16359878/vim-how-to-map-shift-enter
autocmd CmdwinEnter * nnoremap <CR> <CR>
autocmd BufReadPost quickfix nnoremap <CR> <CR>

" Detects mutt filetypes
augroup filetypedetect
  " Mail
  autocmd BufRead,BufNewFile *mutt-*			  setfiletype mail
augroup END

autocmd BufRead,BufNewFile *.tex,*.anki_vim let b:delimitMate_quotes = "\" ' $"
" Disables auto-comments on newlines and disables autowrap
autocmd FileType py,vim,sh,zsh,tex setlocal formatoptions-=ro
autocmd FileType * setlocal formatoptions-=t
autocmd FileType man setlocal nowrap
autocmd BufRead,BufNewFile config set ft=cfg
autocmd BufRead,BufNewFile .coveragerc set ft=cfg
autocmd BufRead,BufNewFile CMakeLists.txt set ft=cmake
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost /usr/include/c++/**/* set ft=cpp

"""""""""""""""""""""
"  Custom Commands  "
"""""""""""""""""""""
" Redraws screen after silent command
command! -nargs=1 Silent
\   execute 'silent !' . <q-args>
\ | execute 'redraw!'

"""""""""""""""
"  Functions  "
"""""""""""""""
let g:S = 0  "result in global variable S
function! Sum(number)
  let g:S = g:S + a:number
  return a:number
endfunction

function! s:VSetSearch(cmdtype)
	let temp = @s
	norm! gv"sy
	let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
	let @s = temp
endfunction

" Used to switch to and from test files
function! _SwitchToTest(ext, fcmd)
    let basename = expand('%:t:r')
    if basename =~ 'test_.*'
        let pyfile = split(basename, "_")[1]
        exec a:fcmd . " " . pyfile . "." . a:ext
    else
        exec a:fcmd . " test_" . basename . "." . a:ext
    endif
endfunction

function! SwitchToTest(ext)
    call _SwitchToTest(a:ext, 'find')
endfunction

function! VSwitchToTest(ext)
    call _SwitchToTest(a:ext, 'vert sf')
endfunction

" Automatically creates directory if it does not already exist
" https://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save
function s:MkNonExDir(file, buf)
	if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
		let dir=fnamemodify(a:file, ':h')
		if !isdirectory(dir)
			call mkdir(dir, 'p')
		endif
	endif
endfunction
augroup BWCCreateDir
	autocmd!
	autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  ('.l:branchname.')  ':''
endfunction

highlight VertSplit ctermfg=DarkGrey ctermbg=227
highlight StatusLine cterm=NONE ctermfg=black ctermbg=227
highlight StatusLineNC cterm=NONE ctermfg=black ctermbg=DarkGrey

set statusline=
set statusline+=%{StatuslineGit()}
set statusline+=\ %f
set statusline+=%m\ 
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

function AddPWDtoPath()
    " Appends the current working directory to PATH
    let tempPath=getcwd() . "/**"
    exec "set path+=" . tempPath
endfunction

call AddPWDtoPath()

""""""""""""""""""
"  Load Plugins  "
""""""""""""""""""
if filereadable($CONFIG . "/plugins.vim")
	source $CONFIG/plugins.vim
else
	source /home/bryan/Dropbox/dotfiles/extras/plugins.vim
endif
