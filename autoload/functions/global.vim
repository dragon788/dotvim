" saves all the visible windows if needed/possible
function functions#global#AutoSave()

  let this_window = winnr()

  windo if &buftype != "nofile" && expand('%') != '' && &modified | write | doautocmd BufWritePost | endif

  execute this_window . 'wincmd w'

endfunction

" ===========================================================================

" naive MRU
function functions#global#MRUComplete(ArgLead, CmdLine, CursorPos)
  let my_oldfiles = filter(copy(v:oldfiles), 'v:val =~ a:ArgLead')

  if len(my_oldfiles) > 16
    call remove(my_oldfiles, 17, len(my_oldfiles) - 1)

  endif

  return my_oldfiles

endfunction

function functions#global#MRU(command, arg)
  execute a:command . " " . a:arg

endfunction

" ===========================================================================

" wrapping :cnext/:cprevious and :lnext/:lprevious
" quick and dirty
function functions#global#WrapCommand(direction, prefix)
  if a:direction == "up"
    try
      execute a:prefix . "previous"

    catch /^Vim\%((\a\+)\)\=:E553/
      execute a:prefix . "last"

    catch /^Vim\%((\a\+)\)\=:E776/

    endtry

  elseif a:direction == "down"
    try
      execute a:prefix . "next"

    catch /^Vim\%((\a\+)\)\=:E553/
      execute a:prefix . "first"

    catch /^Vim\%((\a\+)\)\=:E776/

    endtry

  endif

endfunction

" ===========================================================================

" simplistic search/replace across project
function functions#global#Replace(search_pattern, replacement_pattern, file_pattern)

  silent execute "lvimgrep " . a:search_pattern . " " . a:file_pattern

  try
    silent lfirst

    while 1
      execute "%s/" . a:search_pattern . "/" . a:replacement_pattern . "/ec"

      silent lnfile

    endwhile

  catch /^Vim\%((\a\+)\)\=:E\%(553\|42\):/

  endtry

endfunction

" ===========================================================================

" from $VIMRUNTIME/ftplugin/python.vim
function functions#global#Custom_jump(motion) range
  let cnt = v:count1
  let save = @/

  mark '

  while cnt > 0
    silent! execute a:motion

    let cnt = cnt - 1

  endwhile

  call histdel('/', -1)

  let @/ = save

endfunction

" ===========================================================================

" tries to make <CR> a little smarter in insert mode:
" - expands {}, [], (), <tag></tag> 'correctly'
" - removes empty comment marker
" - more?
function functions#global#SmartEnter()
  " beware of the cmdline window
  if &buftype == "nofile"
    return "\<CR>"

  endif

  " I still have to decide if it's useful to me
  if getline(".") =~ '^\s*\(\*\|//\|#\|"\)\s*$'
    return "\<C-u>"

  endif

  let previous = getline(".")[col(".")-2]
  let next     = getline(".")[col(".")-1]

  if previous ==# "{"
    return functions#global#PairExpander(previous, "}", next)

  elseif previous ==# "["
    return functions#global#PairExpander(previous, "]", next)

  elseif previous ==# "("
    return functions#global#PairExpander(previous, ")", next)

  elseif previous ==# ">"
    return functions#global#TagExpander(next)

  else
    return "\<CR>"

  endif

endfunction

function functions#global#PairExpander(left, right, next)
  let pair_position = searchpairpos(a:left, "", a:right, "Wn")

  if a:next !=# a:right && pair_position[0] == 0
    return "\<CR>" . a:right . "\<C-o>==\<C-o>O"

  elseif a:next !=# a:right && pair_position[0] != 0 && indent(pair_position[0]) != indent(".")
    return "\<CR>" . a:right . "\<C-o>==\<C-o>O"

  elseif a:next ==# a:right
    return "\<CR>\<C-o>==\<C-o>O"

  else
    return "\<CR>"

  endif

endfunction

function functions#global#TagExpander(next)
  if a:next ==# "<" && getline(".")[col(".")] ==# "/"
    if getline(".")[searchpos("<", "bnW")[1]] ==# "/" || getline(".")[searchpos("<", "bnW")[1]] !=# getline(".")[col(".") + 1]
      return "\<CR>"

    else
      return "\<CR>\<C-o>==\<C-o>O"

    endif

  else
    return "\<CR>"

  endif

endfunction
" ===========================================================================

" return a representation of the selected text
" suitable for use as a search pattern
function functions#global#GetVisualSelection()
  let old_reg = @v

  normal! gv"vy

  let raw_search = @v
  let @v = old_reg

  return substitute(escape(raw_search, '\/.*$^~[]'), "\n", '\\n', "g")

endfunction

" ===========================================================================

" DOS to UNIX encoding
function functions#global#ToUnix()
  mark `

  silent update
  silent e ++ff=dos
  silent setlocal ff=unix
  silent w

  silent ``

endfunction
