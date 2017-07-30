function! s:SetGlobalOption(opt, val)
  if !exists("g:" . a:opt)
    let g:{a:opt} = a:val
  endif
endfunction

call s:SetGlobalOption("todo_working", "[ ]")
call s:SetGlobalOption("todo_done", "[x]")
call s:SetGlobalOption("todo_cancled", "[X]")

call s:SetGlobalOption("todo_working_icon", "☐ ")
call s:SetGlobalOption("todo_done_icon", "☑ ")
call s:SetGlobalOption("todo_canceled_icon", "☒ ")
