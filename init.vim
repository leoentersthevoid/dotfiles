" leoentersthevoid
"
" References: 
" -----------
" http://vim.fisadev.com 12.0.1

set encoding=utf-8
let using_neovim=has('nvim')
let using_vim=!using_neovim

" Vim-plug initialization
" -----------------------

let vim_plug_just_installed=0
if using_neovim
    let vim_plug_path = expand('~/.config/nvim/autoload/plug.vim')
else
    let vim_plug_path = expand('~/.vim/autoload/plug.vim')
endif

if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    if using_neovim
       silent !mkdir -p ~/.config/nvim/autoload
       silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   else
        silent !mkdir -p ~/.vim/autoload
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    endif
    let vim_plug_just_installed=1
endif

" manually load vim-plug the first time
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif

" Active plugins
" --------------

if using_neovim
    call plug#begin("~/.config/nvim/plugged")
else
    call plug#begin("~/.vim/plugged")
endif

" Override configs by directory (https://github.com/arielrossanigo/dir-configs-override.vim)
Plug 'arielrossanigo/dir-configs-override.vim'

" Code commenter (https://github.com/preservim/nerdcommenter)
Plug 'scrooloose/nerdcommenter' 

" Better file browser (https://github.com/preservim/nerdtree)
Plug 'scrooloose/nerdtree'

" Class/module browser (https://github.com/preservim/tagbar)
Plug 'majutsushi/tagbar'

" Search results counter (https://github.com/vim-scripts/IndexedSearch)
Plug 'vim-scripts/IndexedSearch'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git/mercurial/others diff icons on the side of the file lines (https://github.com/mhinz/vim-signify)
Plug 'mhinz/vim-signify'

" Code and files fuzzy finder (https://github.com/junegunn/fzf.vim)
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Pending tasks list (https://github.com/fisadev/FixedTaskList.vim)
Plug 'fisadev/FixedTaskList.vim'

" Autocompletion (https://github.com/neoclide/coc.nvim)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Completion from other opened files (https://github.com/Shougo/context_filetype.vim)
Plug 'Shougo/context_filetype.vim'

" Automatically close parenthesis (https://github.com/Townk/vim-autoclose)
Plug 'Townk/vim-autoclose'

" Ack code search (https://github.com/mileszs/ack.vim)
" [!!!] requires ack installed in the system [!!!]
Plug 'mileszs/ack.vim'

" Paint css colors with the real color (https://github.com/lilydjwg/colorizer)
" e.g. #79f 
Plug 'lilydjwg/colorizer' 

" Window chooser (https://github.com/t9md/vim-choosewin)
Plug 't9md/vim-choosewin'

" Git integration (https://github.com/tpope/vim-fugitive)
Plug 'tpope/vim-fugitive'

" Relative numbering of lines (https://github.com/myusuf3/numbers.vim)
Plug 'myusuf3/numbers.vim'

" A Vim Plugin for Lively Previewing LaTeX PDF Output (https://github.com/xuhdev/vim-latex-live-preview)
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

" Nicely align stuff (godlygeek/tabular)
Plug 'godlygeek/tabular'

if using_vim
    " Consoles as buffers (https://code.google.com/archive/p/conque/)
    Plug 'rosenfeld/conque-term'
endif

call plug#end()

" Install plugins the first time vim runs
if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif

" Vim settings and mappings
" -------------------------
 
if using_vim
    " A bunch of things that are set by default in neovim, but not in vim

    " no vi-compatible
    set nocompatible

    " allow plugins by file type (required for plugins!)
    filetype plugin on
    filetype indent on

    " always show status bar
    set ls=2

    " incremental search
    set incsearch
    " highlighted search results
    set hlsearch

    " syntax highlight on
    syntax on

    " better backup, swap and undos storage for vim (nvim has nice ones by
    " default)
    set directory=~/.vim/dirs/tmp     " directory to place swap files in
    set backup                        " make backup files
    set backupdir=~/.vim/dirs/backups " where to put backup files
    set undofile                      " persistent undos - undo after you re-open the file
    set undodir=~/.vim/dirs/undos
    set viminfo+=n~/.vim/dirs/viminfo
    " create needed directories if they don't exist
    if !isdirectory(&backupdir)
        call mkdir(&backupdir, "p")
    endif
    if !isdirectory(&directory)
        call mkdir(&directory, "p")
    endif
    if !isdirectory(&undodir)
        call mkdir(&undodir, "p")
    endif
end

" tabs and spaces handling
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" show line numbers
set nu

" remove ugly vertical lines on window division
set fillchars+=vert:\ 

" use 256 colors when possible
if has('gui_running') || using_neovim || (&term =~? 'mlterm\|xterm\|xterm-256\|screen-256')
    if !has('gui_running')
        let &t_Co = 256
    endif
endif

" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest

" save as sudo
ca w!! w !sudo tee "%"

" tab navigation mappings
map tt :tabnew
map <M-Right> :tabn<CR>
map <M-Left> :tabp<CR>
imap <M-Right> <ESC>:tabn<CR>
imap <M-Left> <ESC>:tabp<CR>

" buffer navigation
map gnn :bn<cr>
map gpp :bp<cr> 
map gdd :bd<cr>

" better transition from insert mode to normal mode 
" if you're using a Mac:
imap §§ <Esc>
" if you're using a Linux:
"imap `` <Esc>

" find and replace
nnoremap S :%s//g<Left><Left>
" clear search results (after pressing # or /val)
nnoremap <silent> // :noh<CR>

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=10

" clear empty spaces at the end of lines on save of python files
autocmd BufWritePre *.py :%s/\s\+$//e

" fix problems with uncommon shells (fish, xonsh) and plugins running commands
set shell=/bin/bash 

" Plugins settings 
" -----------------------------

" coc 

set updatetime=300
set cmdheight=2
set hidden
set shortmess+=c

" use <Tab> and <S-Tab> to navigate the completion list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" goto code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" toggle tagbar display
map <ESC><ENTER> :TagbarToggle<CR>
" autofocus on tagbar open
let g:tagbar_autofocus = 1

" toggle NerdTree easier
map <ESC><ESC> :NERDTreeToggle<CR>  

" don't show these file types
let NERDTreeIgnore = ['\.pyc$', '\.pyo$']

" enable folder icons
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1

" fix directory colors
highlight! link NERDTreeFlags NERDTreeDir

" remove expandable arrow
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let NERDTreeDirArrowExpandable = "\u00a0"
let NERDTreeDirArrowCollapsible = "\u00a0"
let NERDTreeNodeDelimiter = "\x07"

" autorefresh on tree focus
function! NERDTreeRefresh()
    if &filetype == "nerdtree"
        silent exe substitute(mapcheck("R"), "<CR>", "", "")
    endif
endfunction

autocmd BufEnter * call NERDTreeRefresh()

" show pending tasks list
map <F2> :TaskList<CR>

" file finder mapping
nmap ,e :Files<CR>
" tags (symbols) in current file finder mapping
nmap ,g :BTag<CR>
" the same, but with the word under the cursor pre filled
nmap ,wg :execute ":BTag " . expand('<cword>')<CR>
" tags (symbols) in all files finder mapping
nmap ,G :Tags<CR>
" the same, but with the word under the cursor pre filled
nmap ,wG :execute ":Tags " . expand('<cword>')<CR>
" general code finder in current file mapping
nmap ,f :BLines<CR>
" the same, but with the word under the cursor pre filled
nmap ,wf :execute ":BLines " . expand('<cword>')<CR>
" general code finder in all files mapping
nmap ,F :Lines<CR>
" the same, but with the word under the cursor pre filled
nmap ,wF :execute ":Lines " . expand('<cword>')<CR>
" commands finder mapping
nmap ,c :Commands<CR>

nmap ,r :Ack 
nmap ,wr :execute ":Ack " . expand('<cword>')<CR>

" mapping
nmap  -  <Plug>(choosewin)

" show big letters
let g:choosewin_overlay_enable = 1

" signify

" nicer colors
highlight DiffAdd           cterm=bold ctermbg=237  ctermfg=119
highlight DiffDelete        cterm=bold ctermbg=237  ctermfg=167
highlight DiffChange        cterm=bold ctermbg=237  ctermfg=237
highlight SignifySignAdd    cterm=bold ctermbg=237  ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227

set updatetime=100

"this first setting decides in which order try to guess your current vcs
let g:signify_vcs_list = ['git', 'hg']
let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}

" Custom configurations 
" ---------------------

" include user's custom nvim configurations
if using_neovim
    let custom_configs_path = "~/.config/nvim/custom.vim"
else
    let custom_configs_path = "~/.vim/custom.vim"
endif

if filereadable(expand(custom_configs_path))
  execute "source " . custom_configs_path
endif

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif

colorscheme gruvbox
let $NVIM_TUI_ENABLE_TRUE_COLOR = 1

