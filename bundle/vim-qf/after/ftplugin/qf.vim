" qf.vim - Tame the quickfix window
" Maintainer:	romainl <romainlafourcade@gmail.com>
" Version:	0.0.1
" License:	Vim License (see :help license)
" Location:	after/ftplugin/qf.vim
" Website:	https://github.com/romainl/vim-qf
"
" See qf.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help qf.txt

let s:save_cpo = &cpo
set cpo&vim

let b:undo_ftplugin = "setl fo< com< ofu<"

" text wrapping is useless in the quickfix window
setlocal nowrap
" relative line numbers don't make much sense either
" but absolute numbers do
setlocal norelativenumber
setlocal number
" we don't want quickfix buffers to pop up when doing :bn or :bp
set nobuflisted

" are we in a location list or a quickfix list?
let b:isLoc = len(getloclist(0)) > 0 ? 1 : 0

" force the quickfix window to be opened at the bottom
" of the screen and take the full width
wincmd J

" inspired by Ack.vim
if exists("g:qf_mapping_ack_style")
    " open entry in a new horizontal window
    nnoremap <buffer> s <C-w><CR>
    " open entry in a new vertical window.
    nnoremap <buffer> v <C-w><CR><C-w>L<C-w>p<C-w>J<C-w>p
    " open entry in a new tab.
    nnoremap <buffer> t <C-w><CR><C-w>T
    " open entry and come back
    nnoremap <buffer> o <CR><C-w>p
    " open entry and close the location/quickfix window.
    if b:isLoc == 1
        nnoremap <buffer> O <CR>:lclose<CR>
    else
        nnoremap <buffer> O <CR>:cclose<CR>
    endif
endif

" filter the location/quickfix list
" usage:
" :Filter foo
" or:
" § with the cursor on a word
command! -buffer -nargs=* Filter call qf#FilterList(<q-args>)
if exists("g:qf_mapping_filter")
    execute "nnoremap <silent> <buffer> " . g:qf_mapping_filter . " :Filter <C-r><C-f><CR>"
else
    nnoremap <silent> <buffer> § :Filter <C-r><C-f><CR>
endif

" restore the location/quickfix list
" usage:
" :Restore
command! -buffer Restore call qf#RestoreList()
if exists("g:qf_mapping_restore")
    execute "nnoremap <silent> <buffer> " . g:qf_mapping_restore . " :Restore<CR>"
else
    nnoremap <silent> <buffer> <F5> :Restore<CR>
endif

" do something on each line in the location/quickfix list
" usage:
" :Doline s/^/---
command! -buffer -nargs=1 Doline call qf#DoList(1, <q-args>)

" do something on each file in the location/quickfix list
" usage:
" :Dofile %s/^/---
command! -buffer -nargs=1 Dofile call qf#DoList(0, <q-args>)

" quit Vim if the last window is a quickfix window
autocmd qf BufEnter <buffer> if winnr('$') < 2 | q | endif

let &cpo = s:save_cpo
