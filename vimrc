filetype off
syntax off

call pathogen#infect()

filetype plugin indent on
syntax on

runtime macros/matchit.vim

""""""""""""""""""""
" GENERIC SETTINGS "
""""""""""""""""""""
" basic
set backspace=indent,eol,start
set hidden
set incsearch
set laststatus=2
set switchbuf=useopen,usetab
set tags=./tags;,tags;
set wildmenu

" fancy
set autoindent
set expandtab
set shiftround
set shiftwidth=4
set smarttab

set gdefault
set ignorecase
set smartcase

set encoding=utf-8
set termencoding=utf-8

set wildcharm=<C-z>
set wildignore=*.swp,*.bak
set wildignore+=*.pyc,*.class,*.sln,*.Master,*.csproj,*.csproj.user,*.cache,*.dll,*.pdb,*.min.*
set wildignore+=*/.git/**/*,*/.hg/**/*,*/.svn/**/*
set wildignore+=tags
set wildignore+=*.tar.*
set wildignorecase
set wildmode=list:full

set statusline=%<\ %f\ %m%y%w%=\ L:\ \%l\/\%L\ C:\ \%c\ 

set list
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·

set foldlevelstart=999
set foldmethod=indent
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

set splitbelow
set splitright

set completeopt+=longest
set cursorline
set fileformats=unix,dos,mac
set formatoptions+=1
set mouse=a
set nostartofline
set noswapfile
set nrformats-=octal
set path=.,**
set previewheight=1
set scrolloff=4
set tags^=./.temptags
set virtualedit=block

let mapleader = ","
" available keys for <leader> mappings: a c e    jklmno qr  u wxyz
"                                       A CDE GHIJKLMNOPQR  U WXYZ

""""""""""
" COLORS "
""""""""""
colorscheme apprentice

"""""""""""""""""""""
" DEFAULT BEHAVIORS "
"""""""""""""""""""""
augroup VIMRC
  autocmd!

  autocmd FocusLost,InsertLeave * call functions#global#AutoSave()

  autocmd VimEnter,GUIEnter * set visualbell t_vb=

  autocmd BufLeave * let b:winview = winsaveview()
  autocmd BufEnter * if exists('b:winview') | call winrestview(b:winview) | endif

  autocmd BufLeave *.css,*.less normal! mC
  autocmd BufLeave *.html       normal! mH
  autocmd BufLeave *.js         normal! mJ
  autocmd BufLeave *.php        normal! mP
  autocmd BufLeave vimrc,*.vim  normal! mV

augroup END

"""""""""""""""""""""""""""""""""
" ENVIRONMENT-SPECIFIC SETTINGS "
"""""""""""""""""""""""""""""""""
let os=substitute(system('uname'), '\n', '', '')

if has('gui_running')

  set guioptions-=T

  set lines=40
  set columns=140

  if os == 'Darwin'
    set guifont=Fira\ Mono:h12
    set fuoptions=maxvert,maxhorz
    set clipboard^=unnamed

  elseif os == 'Linux'
    set guifont=Inconsolata-g\ Medium\ 10
    set guioptions-=m
    set clipboard^=unnamedplus

  endif

else
  if os == 'Darwin'
    set clipboard^=unnamed

  elseif os == 'Linux'
    set clipboard^=unnamedplus

  endif

  if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"

  endif

  " allows clicking after the 223rd column
  if has('mouse_sgr')
    set ttymouse=sgr

  endif

  nnoremap <Esc>A <up>
  nnoremap <Esc>B <down>
  nnoremap <Esc>C <right>
  nnoremap <Esc>D <left>
  inoremap <Esc>A <up>
  inoremap <Esc>B <down>
  inoremap <Esc>C <right>
  inoremap <Esc>D <left>

endif

"""""""""""""""""""""""
" JUGGLING WITH FILES "
"""""""""""""""""""""""
nnoremap <leader>f :find *
nnoremap <leader>F :find <C-R>=expand('%:p:h').'/**/*'<CR>
nnoremap <leader>s :sfind *
nnoremap <leader>S :sfind <C-R>=expand('%:p:h').'/**/*'<CR>
nnoremap <leader>v :vert sfind *
nnoremap <leader>V :vert sfind <C-R>=expand('%:p:h').'/**/*'<CR>

command! -nargs=1 -complete=customlist,functions#global#MRUComplete ME call functions#global#MRU('edit', <f-args>)
command! -nargs=1 -complete=customlist,functions#global#MRUComplete MS call functions#global#MRU('split', <f-args>)
command! -nargs=1 -complete=customlist,functions#global#MRUComplete MV call functions#global#MRU('vsplit', <f-args>)
command! -nargs=1 -complete=customlist,functions#global#MRUComplete MT call functions#global#MRU('tabedit', <f-args>)

"""""""""""""""""""""""""
" JUGGLING WITH BUFFERS "
"""""""""""""""""""""""""
nnoremap <leader>b :buffer <C-z><S-Tab>
nnoremap <leader>B :sbuffer <C-z><S-Tab>

nnoremap gb :buffers<CR>:buffer<Space>
nnoremap gB :buffers<CR>:sbuffer<Space>

nnoremap <PageUp>   :bprevious<CR>
nnoremap <PageDown> :bnext<CR>

"""""""""""""""""""""""""
" JUGGLING WITH WINDOWS "
"""""""""""""""""""""""""
nnoremap <C-Down> <C-w>w
nnoremap <C-Up>   <C-w>W

"""""""""""""""""""""""
" JUGGLING WITH LINES "
"""""""""""""""""""""""
nnoremap <leader><Up>   :move-2<CR>==
nnoremap <leader><Down> :move+<CR>==
xnoremap <leader><Up>   :move-2<CR>gv=gv
xnoremap <leader><Down> :move'>+<CR>gv=gv

"""""""""""""""""""""""
" JUGGLING WITH WORDS "
"""""""""""""""""""""""
nnoremap <leader><Left>  "_yiw?\v\w+\_W+%#<CR>:s/\v(%#\w+)(\_W+)(\w+)/\3\2\1/<CR><C-o><C-l>
nnoremap <leader><Right> "_yiw:s/\v(%#\w+)(\_W+)(\w+)/\3\2\1/<CR><C-o>/\v\w+\_W+<CR><C-l>

"""""""""""""""""""""""""""""
" JUGGLING WITH COMPLETIONS "
"""""""""""""""""""""""""""""
inoremap <expr> <CR> pumvisible() ? '\<C-y>' : '\<CR>'

inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '\<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '\<S-Tab>'

inoremap <expr> <leader>, pumvisible() ? '<C-x><C-o>' : '<C-x><C-o><C-p><C-p><Down>'
inoremap <expr> <leader>/ pumvisible() ? '<C-x><C-f>' : '<C-x><C-f><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <leader>- pumvisible() ? '<C-x><C-l>' : '<C-x><C-l><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <leader>= pumvisible() ? '<C-x><C-n>' : '<C-x><C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

""""""""""""""""""""""""""
" JUGGLING WITH SEARCHES "
""""""""""""""""""""""""""
nnoremap [I [I:

if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
  set grepformat=%f:%l:%c:%m,%f:%l:%m

  nnoremap K :silent! lgrep! "\b<C-r><C-w>\b"<CR>:lwindow<CR>:redraw!<CR>

  command! -nargs=+ -complete=file_in_path -bar Grep silent! lgrep! <args> | lwindow | redraw!

endif

""""""""""""""""""""""""""""""""
" JUGGLING WITH SEARCH/REPLACE "
""""""""""""""""""""""""""""""""
nnoremap <Space><Space> :'{,'}s/\<<C-r>=expand('<cword>')<CR>\>/
nnoremap <Space>%       :%s/\<<C-r>=expand('<cword>')<CR>\>/

xnoremap <Space><Space> :<C-u>'{,'}s/<C-r>=functions#global#GetVisualSelection()<CR>/
xnoremap <Space>%       :<C-u>%s/<C-r>=functions#global#GetVisualSelection()<CR>/

nnoremap <Space>f mf?function<CR>$v%<Esc>`f:'<,'>s/\<<C-r>=expand('<cword>')<CR>\>/
nnoremap <Space>b m`vi(<Esc>``:'<,'>s/\<<C-r>=expand('<cword>')<CR>\>/
nnoremap <Space>B m`vi{<Esc>``:'<,'>s/\<<C-r>=expand('<cword>')<CR>\>/
nnoremap <Space>[ m`vi[<Esc>``:'<,'>s/\<<C-r>=expand('<cword>')<CR>\>/
nmap     <Space>] <Space>[

command! -nargs=+ -complete=file_in_path Replace call functions#global#Replace(<f-args>)

"""""""""""""""""""""""""
" JUGGLING WITH CHANGES "
"""""""""""""""""""""""""
nnoremap <leader>; *``cgn
nnoremap <leader>: #``cgN

xnoremap <leader>; <Esc>:let @/ = functions#global#GetVisualSelection()<CR>cgn
xnoremap <leader>: <Esc>:let @/ = functions#global#GetVisualSelection()<CR>cgN

""""""""""""""""""""""""""""""""""""""
" JUGGLING WITH ERRORS AND LOCATIONS "
""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <Home>   :call functions#global#WrapCommand('up', 'c')<CR>
nnoremap <silent> <End>    :call functions#global#WrapCommand('down', 'c')<CR>

nnoremap <silent> <C-Home> :call functions#global#WrapCommand('up', 'l')<CR>
nnoremap <silent> <C-End>  :call functions#global#WrapCommand('down', 'l')<CR>

""""""""""""""""""""""
" JUGGLING WITH TAGS "
""""""""""""""""""""""
command! Tagit  call functions#tags#Tagit()
command! Bombit call functions#tags#Bombit(0)

command! -nargs=1 -complete=customlist,functions#tags#BtagComplete Btag call functions#tags#Btag(<f-args>)

nnoremap <leader>t :Bombit<CR>:tjump /
nnoremap <leader>T :call functions#tags#Bombit(1)<CR>:Btag <C-z><S-Tab>

nnoremap <leader>p :Bombit<CR>:ptjump /

nnoremap g] :Bombit<CR>g<C-]>

"""""""""""""""""""""""""
" JUGGLING WITH NUMBERS "
"""""""""""""""""""""""""
xnoremap <C-a> :<C-u>let vcount = v:count ? v:count : 1 <bar> '<,'>s/\%V\d\+/\=submatch(0) + vcount<cr>gv
xnoremap <C-x> :<C-u>let vcount = v:count ? v:count : 1 <bar> '<,'>s/\%V\d\+/\=submatch(0) - vcount<cr>gv

xnoremap <leader>i :call functions#global#Incr()<CR>

""""""""""""""""""""
" VARIOUS MAPPINGS "
""""""""""""""""""""
nnoremap <leader>d "_d
xnoremap <leader>d "_d

xnoremap <leader>p "_dP

nnoremap Y y$

xnoremap > >gv
xnoremap < <gv

nnoremap <leader><Space><Space> m`o<Esc>kO<Esc>``

cnoremap <C-a> <Home>
cnoremap <C-e> <End>

nnoremap <Down> gj
nnoremap <up>   gk

" merci twal
onoremap w :<C-u>norm w<CR>
onoremap W :<C-u>norm W<CR>

inoremap <expr> <CR> functions#global#SmartEnter()

cnoremap %% <C-r>=expand('%')<CR>
cnoremap :: <C-r>=expand('%:p:h')<CR>

nnoremap gV `[v`]

nnoremap cy :call functions#global#Cycle()<CR>

nnoremap mù m`
nnoremap ùù ``

"""""""""""""""""""""""
" CUSTOM TEXT-OBJECTS "
"""""""""""""""""""""""
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '%', '"', "'" ]
  execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
  execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
  execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
  execute 'onoremap a' . char . ' :normal va' . char . '<CR>'

endfor

""""""""""""""""""""
" VARIOUS COMMANDS "
""""""""""""""""""""
command! ToUnix call functions#global#ToUnix()

command! SS echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

command! LCD lcd %:p:h
command! CD  cd %:p:h

command! -range=% TR mark ` | execute <line1> . ',' . <line2> . 's/\s\+$//' | normal! ``

command! TD tselect TODO
command! FM tselect FIXME

command! EV tabnew $MYVIMRC <bar> lcd %:p:h
command! SV source $MYVIMRC

" sharing is caring
command! -range=% VP  execute <line1> . "," . <line2> . "w !vpaste ft=" . &filetype
command!          CMD let @+ = ':' . @:

"""""""""""""""""""
" PLUGIN SETTINGS "
"""""""""""""""""""
let g:snippets_dir = '~/.vim/snippets/'

let g:netrw_winsize   = '30'
let g:netrw_banner    = 0
let g:netrw_keepdir   = 1
let g:netrw_liststyle = 3

let g:html_indent_script1 = 'inc'
let g:html_indent_style1  = 'inc'
let g:html_indent_inctags = 'html,body,head,tbody,p,li,dd,dt,h1,h2,h3,h4,h5,h6,blockquote'

let g:sparkup = '~/.vim/bundle/sparkup/ftplugin/html/sparkup.py'
