setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal formatoptions=croql
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class

nnoremap <buffer> ,g I# <Esc>A #<Esc>yyp0lv$hhr-yykPjj
