" TODO Syntax File
" Language: TODO
" Maintainer: Arden Rasmussen

if exists("b:current_syntax")
  finish
endif

runtime! syntax/html.vim

syn spell toplevel

let b:regesc='[]()?.*@='

function s:CreateRegion(name, start, end, options, matchgroup)
  let matchgroup = a:matchgroup != ''?
    \ (' matchgroup=' . a:matchgroup) : 
    \ ''
  exec 'syn region ' . a:name . matchgroup . ' start=/' . a:start . '/ end=/' . a:end . '/ ' . a:options
endfunction

function s:CreateNonContainedMatch(name, regex, conceal)
  let conceal = a:conceal != ''?
    \ (a:conceal) :
    \ ''
  exec 'syn match ' . a:name . ' /' . a:regex . '/ ' . conceal
endfunction

function s:CreateMatch(name, regex, conceal)
  let conceal = a:conceal != ''?
    \ (a:conceal) :
    \ ''
  exec 'syn match ' . a:name . ' /' . a:regex . '/ contained ' . conceal
endfunction

let b:todoWorking=escape(g:todo_working, b:regesc)

call s:CreateRegion('todoWorking', escape(g:todo_working, b:regesc), '$', 'fold contains=@todo,@todoPri,todoBox,todoBoxDone,todoBullet,todoItalic,todoBold', '')
call s:CreateRegion('todoDone', escape(g:todo_done, b:regesc), '$', 'fold contains=@todoPri,todoBox,todoBoxDone,todoItalic,todoBold,todoDate', '')

call s:CreateRegion('todoItalic', '\*', '\*', 'concealends', 'todoDelimiter')
call s:CreateRegion('todoBold', '\*\*', '\*\*', 'concealends', 'todoDelimiter')

call s:CreateRegion('htmlH1', '^\s*#', '\($\|[^\\]#\+\)', 'concealends', 'todoDelimiter')
call s:CreateRegion('htmlH2', '^\s*##', '\($\|[^\\]#\+\)', 'concealends', 'todoDelimiter')
call s:CreateRegion('htmlH3', '^\s*###', '\($\|[^\\]#\+\)', 'concealends', 'todoDelimiter')
call s:CreateRegion('htmlH4', '^\s*####', '\($\|[^\\]#\+\)', 'concealends', 'todoDelimiter')
call s:CreateRegion('htmlH5', '^\s*#####', '\($\|[^\\]#\+\)', 'concealends', 'todoDelimiter')
call s:CreateRegion('htmlH6', '^\s*######', '\($\|[^\\]#\+\)', 'concealends', 'todoDelimiter')

call s:CreateRegion('todoComment', '\/\*', '\*\/', 'fold concealends', 'todoDelimiter')

call s:CreateMatch('todo1', '\v(\(1\)\s)@<=.*', '')
call s:CreateMatch('todo2', '\v(\(2\)\s)@<=.*', '')
call s:CreateMatch('todo3', '\v(\(3\)\s)@<=.*', '')
call s:CreateMatch('todo4', '\v(\(4\)\s)@<=.*', '')
call s:CreateMatch('todo5', '\v(\(5\)\s)@<=.*', '')
call s:CreateMatch('todo6', '\v(\(6\)\s)@<=.*', '')
call s:CreateMatch('todo7', '\v(\(7\)\s)@<=.*', '')
call s:CreateMatch('todo8', '\v(\(8\)\s)@<=.*', '')

call s:CreateMatch('todoPri1', '\v(\(1\)\s)', 'conceal')
call s:CreateMatch('todoPri2', '\v(\(2\)\s)', 'conceal')
call s:CreateMatch('todoPri3', '\v(\(3\)\s)', 'conceal')
call s:CreateMatch('todoPri4', '\v(\(4\)\s)', 'conceal')
call s:CreateMatch('todoPri5', '\v(\(5\)\s)', 'conceal')
call s:CreateMatch('todoPri6', '\v(\(6\)\s)', 'conceal')
call s:CreateMatch('todoPri7', '\v(\(7\)\s)', 'conceal')
call s:CreateMatch('todoPri8', '\v(\(8\)\s)', 'conceal')

syn cluster todo contains=todo1,todo2,todo3,todo4,todo5,todo6,todo7,todo8
syn cluster todoPri contains=todoPri1,todoPri2,todoPri3,todoPri4,todoPri5,todoPri6,todoPri7,todoPri8

call s:CreateMatch('todoDate', '\v' . escape(g:todo_date_sym, b:regesc) . '\(([^)]+)\)\@=', 'conceal')

call s:CreateNonContainedMatch('todoBullet', '\v[-+]', 'conceal cchar=' . escape(g:todo_bullet, b:regesc))

if g:todo_use_icon == 1
  call s:CreateMatch('todoBox', escape(g:todo_working, b:regesc), 'conceal cchar=' . escape(g:todo_working_icon, b:regesc))
  call s:CreateMatch('todoBoxDone', escape(g:todo_done, b:regesc), 'conceal cchar=' . escape(g:todo_done_icon, b:regesc))
else
  call s:CreateMatch('todoBox', escape(g:todo_working, b:regesc), '')
  call s:CreateMatch('todoBoxDone', escape(g:todo_done, b:regesc), '')
endif

hi def todoItalic cterm=italic term=italic gui=italic
hi def link todoItalicEnd todoItalic
hi def todoBold cterm=bold term=bold gui=bold

hi def todo1 ctermfg=1
hi def link todoPri1 todo1
hi def todo2 ctermfg=9
hi def link todoPri2 todo2
hi def todo3 ctermfg=3
hi def link todoPri3 todo3
hi def todo4 ctermfg=5
hi def link todoPri4 todo4
hi def todo5 ctermfg=13
hi def link todoPri5 todo5
hi def todo6 ctermfg=6
hi def link todoPri6 todo6
hi def todo7 ctermfg=5
hi def link todoPri7 todo7
hi def todo8 ctermfg=2
hi def link todoPri8 todo8

hi def link todoDone Comment

hi def link todoBox Comment
hi def link todoComment Comment
hi def todoBoxDone ctermfg=2

hi def link todoDelimiter Delimiter

setlocal formatoptions+=r "Automatically insert bullets
setlocal formatoptions-=c "Do not automatically insert bullets when auto-wrapping with text-width
setlocal comments=b:*,b:+,b:- "Accept various markers as bullets

let b:current_syntax = "todo"
