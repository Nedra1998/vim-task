function! s:SetGlobalOption(opt, val)
  if !exists("g:" . a:opt)
    let g:{a:opt} = a:val
  endif
endfunction

call s:SetGlobalOption("todo_date_format", "%H:%M %d-%m-%Y")
call s:SetGlobalOption("todo_date_sym", "#")

call s:SetGlobalOption("todo_working", "[ ]")
call s:SetGlobalOption("todo_done", "[x]")
call s:SetGlobalOption("todo_bullet", "•")
call s:SetGlobalOption("todo_use_icon", 0)
call s:SetGlobalOption("todo_working_icon", "☐")
call s:SetGlobalOption("todo_done_icon", "☑")

let b:regesc = '[]()?.*@='

let s:reg_project = '^\s*#+.*#+$'
let s:reg_marker = join([escape(g:todo_working,b:regesc), escape(g:todo_done,b:regesc)], '\|')
let s:reg_done = escape(g:todo_done,b:regesc)
let s:reg_date = '\v#\(([^)]+)\)$'

nnoremap <buffer> <leader>n :call NewTask(1)<CR>
nnoremap <buffer> <leader>N :call NewTask(-1)<CR>
nnoremap <buffer> <leader>d :call TaskComplete()<CR>
nnoremap <buffer> <leader>D :call DeleteTask()<CR>
nnoremap <buffer> <leader>] :call TaskPriority(1)<CR>
nnoremap <buffer> <leader>[ :call TaskPriority(-1)<CR>
nnoremap <buffer> <leader>, :call IndentTask(-1)<CR>
nnoremap <buffer> <leader>. :call IndentTask(1)<CR>

function! IndentTask(direction)
  if a:direction == 1
    exec 'normal v >'
  elseif a:direction == -1
    exec 'normal v <'
  endif
endfunction

function! TaskPriority(direction)
  exec 'normal 0f)h'
  if a:direction == 1
    exec "normal \<C-a>"
  elseif a:direction == -1 && matchstr(getline('.'), '\%' . col('.') . 'c.') != '1'
    exec "normal \<C-x>"
  endif
endfunction

function! SetLineMarker(marker)
  let l:line = getline('.')
  let l:marker_match = match(l:line, s:reg_marker)
  if l:marker_match > -1
    call cursor(line('.'), l:marker_match + 1)
    exec 'normal R' . a:marker
  endif
endfunction

function! AddDate(value)
  let l:value = g:todo_date_sym . '(' . a:value . ')'
  exec 'normal A ' . l:value
endfunction

function! RemoveDate()
  let l:line = getline('.')
  let l:date_start = match(l:line, s:reg_date)
  echom l:date_start
  if l:date_start > -1
    let l:date_end = matchend(l:line, s:reg_date)
    let l:diff = (l:date_end - l:date_start) + 1
    call cursor(line('.'), l:date_start)
    exec 'normal ' . l:diff . 'dl'
  endif
endfunction

function! NewTask(direction)
  let l:line = getline('.')
  let l:is_match = match(l:line, s:reg_project)
  let l:text = '- ' . g:todo_working . ' (4) '
  if a:direction == -1
    exec 'normal O' . l:text
  elseif a:direction == 1
    exec 'normal o' . l:text
  endif
  if l:is_match > -1
    exec 'normal >>'
  endif
  startinsert!
endfunction

function! DeleteTask()
  exec ':d'
endfunction

function! TaskComplete()
  let l:line = getline('.')
  let l:is_match = match(l:line, s:reg_marker)
  let l:done_match = match(l:line, s:reg_done)

  if l:is_match > -1
    if l:done_match > -1
      call SetLineMarker(g:todo_working)
      call RemoveDate()
    else
      call SetLineMarker(g:todo_done)
      call AddDate(strftime(g:todo_date_format))
    endif
  endif
endfunction
