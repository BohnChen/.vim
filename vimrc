" Minimal Colemak Vim config distilled from the original Neovim config.
" Drop this file at ~/.vimrc. It works without plugins; text-editing plugins
" are loaded only when vim-plug is already installed.

set nocompatible
scriptencoding utf-8

" ---------------------------------------------------------------------------
" Optional plugin manager
" ---------------------------------------------------------------------------
" By default this vimrc never downloads anything on startup. To install
" vim-plug from inside Vim, run:
"   :ColemakInstallPlug
" Then restart Vim and run:
"   :PlugInstall
let s:plug_file = expand('~/.vim/autoload/plug.vim')

function! s:InstallVimPlug() abort
  if filereadable(s:plug_file)
    echo 'vim-plug already exists: ' . s:plug_file
    return
  endif
  if !executable('curl')
    echoerr 'curl not found. Install vim-plug manually into ~/.vim/autoload/plug.vim'
    return
  endif
  call mkdir(fnamemodify(s:plug_file, ':h'), 'p')
  execute 'silent !curl -fLo ' . shellescape(s:plug_file) . ' --create-dirs ' . shellescape('https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  echo 'vim-plug installed. Restart Vim, then run :PlugInstall'
endfunction
command! ColemakInstallPlug call <SID>InstallVimPlug()

let g:colemak_use_plugins = get(g:, 'colemak_use_plugins', 1)
if g:colemak_use_plugins && filereadable(s:plug_file)
  call plug#begin(expand('~/.vim/plugged'))

  " Small, Vim-compatible plugins that directly improve text editing.
  Plug 'tpope/vim-surround'
  Plug 'tomtom/tcomment_vim'
  Plug 'jiangmiao/auto-pairs'
  Plug 'mbbill/undotree'
  Plug 'mg979/vim-visual-multi'
  Plug 'gcmt/wildfire.vim'
  Plug 'junegunn/vim-after-object'
  Plug 'godlygeek/tabular'
  Plug 'tpope/vim-repeat'
  Plug 'svermeulen/vim-subversive'
  Plug 'rhysd/clever-f.vim'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'theniceboy/argtextobj.vim'
  Plug 'theniceboy/vim-move'

  " Plain text / Markdown helpers from the original setup.
  Plug 'dhruvasagar/vim-table-mode', { 'for': ['text', 'markdown', 'vim-plug'] }
  Plug 'dkarter/bullets.vim'
  Plug 'mzlogin/vim-markdown-toc', { 'for': ['markdown', 'vim-plug'] }

  call plug#end()
endif

" ---------------------------------------------------------------------------
" Core editor behavior
" ---------------------------------------------------------------------------
filetype plugin indent on
syntax enable
silent! runtime macros/matchit.vim

if has('multi_byte')
  set encoding=utf-8
  set fileencodings=utf-8,ucs-bom,gb18030,latin1
endif

set hidden
set autoread
set number
set relativenumber
set cursorline
set ruler
set showcmd
set wildmenu
set wildmode=longest:full,full
set backspace=indent,eol,start

set noexpandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent

set list
set listchars=tab:\|\ ,trail:-,extends:>,precedes:<
set scrolloff=4
set sidescrolloff=4
set wrap
set textwidth=0
set foldmethod=indent
set foldlevel=99
set foldenable
set splitright
set splitbelow
set noshowmode
set ignorecase
set smartcase
set incsearch
set hlsearch
set lazyredraw
set novisualbell
set updatetime=300
set virtualedit=block
set completeopt=menuone,longest
set viewoptions=cursor,folds,slash,unix
set timeout
set timeoutlen=700
set ttimeout
set ttimeoutlen=10
silent! set shortmess+=c
silent! set formatoptions-=t
silent! set formatoptions-=c

if exists('&colorcolumn')
  set colorcolumn=100
endif
if exists('&inccommand')
  set inccommand=split
endif
if exists('&termguicolors')
  set termguicolors
endif
if exists('&autochdir')
  set autochdir
endif

let s:vim_tmp = expand('~/.vim/tmp')
if exists('*mkdir')
  silent! call mkdir(s:vim_tmp . '/backup', 'p')
  silent! call mkdir(s:vim_tmp . '/swap', 'p')
  silent! call mkdir(s:vim_tmp . '/undo', 'p')
endif
execute 'set backupdir^=' . fnameescape(s:vim_tmp . '/backup//')
execute 'set directory^=' . fnameescape(s:vim_tmp . '/swap//')
if has('persistent_undo')
  set undofile
  execute 'set undodir^=' . fnameescape(s:vim_tmp . '/undo//')
endif

augroup colemak_core
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
  autocmd BufEnter * silent! lcd %:p:h
  autocmd BufWritePost .vimrc,_vimrc nested source $MYVIMRC
augroup END

" ---------------------------------------------------------------------------
" Basic mappings
" ---------------------------------------------------------------------------
let mapleader = ' '

noremap ; :
nnoremap Q :quit<CR>
nnoremap S :write<CR>
nnoremap <Leader>rc :edit $MYVIMRC<CR>
nnoremap <Leader>rv :edit .vimrc<CR>

" Undo and insert keys, matching the original Colemak habits.
noremap l u
noremap k i
noremap K I

if has('clipboard')
  vnoremap Y "+y
else
  vnoremap Y y
endif

noremap ,. %
vnoremap ki $%
nnoremap <silent> <Leader><CR> :nohlsearch<CR>
nnoremap <Leader>dw /\(\<\w\+\>\)\_s*\1<CR>
nnoremap <Leader>tt :%s/    /\t/g<CR>
vnoremap <Leader>tt :s/    /\t/g<CR>
noremap <silent> <Leader>o za
inoremap <C-y> <Esc>A {}<Esc>i<CR><Esc>ko

" Search next/previous. The original n/N keys are used for Colemak motion.
nnoremap <silent> = nzz
nnoremap <silent> - Nzz

" ---------------------------------------------------------------------------
" Colemak cursor movement
" ---------------------------------------------------------------------------
"     ^
"     u
" < n   i >
"     e
"     v
noremap <silent> u k
noremap <silent> n h
noremap <silent> e j
noremap <silent> i l
noremap <silent> gu gk
noremap <silent> ge gj
noremap <silent> \v v$h

noremap <silent> U 5k
noremap <silent> E 5j
noremap <silent> N 0
noremap <silent> I $
noremap W 5w
noremap B 5b
noremap h e
noremap <C-U> 5<C-y>
noremap <C-E> 5<C-e>

inoremap <C-a> <Esc>A
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <M-b> <S-Left>
cnoremap <M-w> <S-Right>

" ---------------------------------------------------------------------------
" Windows and tabs
" ---------------------------------------------------------------------------
nnoremap <Leader>w <C-w>w
nnoremap <Leader>u <C-w>k
nnoremap <Leader>e <C-w>j
nnoremap <Leader>n <C-w>h
nnoremap <Leader>i <C-w>l
nnoremap qf <C-w>o

noremap s <Nop>
nnoremap su :set nosplitbelow<CR>:split<CR>:set splitbelow<CR>
nnoremap se :set splitbelow<CR>:split<CR>
nnoremap sn :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
nnoremap si :set splitright<CR>:vsplit<CR>
nnoremap <Up> :resize +5<CR>
nnoremap <Down> :resize -5<CR>
nnoremap <Left> :vertical resize -5<CR>
nnoremap <Right> :vertical resize +5<CR>
nnoremap sh <C-w>t<C-w>K
nnoremap sv <C-w>t<C-w>H
nnoremap srh <C-w>b<C-w>K
nnoremap srv <C-w>b<C-w>H
nnoremap <Leader>q <C-w>j:quit<CR>

nnoremap tu :tabedit<CR>
nnoremap tU :tab split<CR>
nnoremap tn :-tabnext<CR>
nnoremap ti :+tabnext<CR>
nnoremap tmn :-tabmove<CR>
nnoremap tmi :+tabmove<CR>

" ---------------------------------------------------------------------------
" Text and Markdown conveniences
" ---------------------------------------------------------------------------
augroup colemak_text
  autocmd!
  autocmd BufRead,BufNewFile *.md,*.markdown setlocal spell
augroup END

nnoremap <Leader><Leader> <Esc>/<++><CR>:nohlsearch<CR>"_c4l
nnoremap <Leader>sc :setlocal spell!<CR>
noremap ` ~
nnoremap <C-c> zz
nnoremap \s :%s//g<Left><Left>
vnoremap \s :s//g<Left><Left>
nnoremap <Leader>sw :set wrap!<CR>
nnoremap \p :echo expand('%:p')<CR>

" ---------------------------------------------------------------------------
" Optional text-plugin configuration
" ---------------------------------------------------------------------------
let g:move_key_modifier = 'C'

let g:bullets_enabled_file_types = [
      \ 'markdown',
      \ 'text',
      \ 'gitcommit',
      \ 'scratch'
      \]

let g:table_mode_cell_text_object_i_map = 'k|'

let g:vmt_cycle_list_item_markers = 1
let g:vmt_fence_text = 'TOC'
let g:vmt_fence_closing_text = '/TOC'

let g:VM_leader = {'default': ',', 'visual': ',', 'buffer': ','}
let g:VM_maps = {}
let g:VM_custom_motions = {'n': 'h', 'i': 'l', 'u': 'k', 'e': 'j', 'N': '0', 'I': '$', 'h': 'e'}
let g:VM_maps['i'] = 'k'
let g:VM_maps['I'] = 'K'
let g:VM_maps['Find Under'] = '<C-k>'
let g:VM_maps['Find Subword Under'] = '<C-k>'
let g:VM_maps['Find Next'] = ''
let g:VM_maps['Find Prev'] = ''
let g:VM_maps['Remove Region'] = 'q'
let g:VM_maps['Skip Region'] = '<C-n>'
let g:VM_maps['Undo'] = 'l'
let g:VM_maps['Redo'] = '<C-r>'

let g:wildfire_objects = {
      \ '*' : ["i'", 'i"', 'i)', 'i]', 'i}', 'it'],
      \ 'html,xml' : ['at', 'it'],
      \}

let g:undotree_DiffAutoOpen = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 8
let g:undotree_SplitWidth = 24
function! g:Undotree_CustomMap() abort
  nmap <buffer> u <Plug>UndotreeNextState
  nmap <buffer> e <Plug>UndotreePreviousState
  nmap <buffer> U 5<Plug>UndotreeNextState
  nmap <buffer> E 5<Plug>UndotreePreviousState
endfunction

function! s:SetupPluginMappings() abort
  if exists(':UndotreeToggle') == 2
    nnoremap L :UndotreeToggle<CR>
  endif

  if exists(':TableModeToggle') == 2
    nnoremap <Leader>tm :TableModeToggle<CR>
  endif

  if exists(':Tabularize') == 2
    vnoremap ga :Tabularize /
  endif

  if exists(':TComment') == 2
    nmap <Leader>cn g>c
    vmap <Leader>cn g>
    nmap <Leader>cu g<c
    vmap <Leader>cu g<
  endif

  if maparg('<Plug>(wildfire-quick-select)', 'n') !=# ''
    map <C-b> <Plug>(wildfire-quick-select)
  endif

  if maparg('<Plug>(SubversiveSubstitute)', 'n') !=# ''
    nmap s <Plug>(SubversiveSubstitute)
    nmap ss <Plug>(SubversiveSubstituteLine)
  endif

  if exists('*after_object#enable')
    call after_object#enable('=', ':', '-', '#', ' ')
  endif
endfunction

augroup colemak_plugin_maps
  autocmd!
  autocmd VimEnter * call <SID>SetupPluginMappings()
augroup END
if !has('vim_starting')
  call s:SetupPluginMappings()
endif

silent! nohlsearch

" Machine-local overrides, intentionally sourced last.
if filereadable(expand('~/.vimrc.local'))
  execute 'source ' . fnameescape(expand('~/.vimrc.local'))
endif
