" setlocal winheight=8
setlocal nowrap
setlocal norelativenumber
setlocal number

wincmd J

" autocmd BufWinLeave <buffer> let &winheight = 999
nnoremap <buffer> <CR> <CR><C-w>p
