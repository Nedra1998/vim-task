if exists("b:current_syntax")
  finish
endif

syn match todoSection /\v%(\S\s*\n)@<!\_^\s*\S.*\n%(([=`'"~^_*+#-])\1*|([:.])\2{2,})\s*$/
syn match todoSection /\v%(\S\s*\n)@<!\_^(([=`:.'"~^_*+#-])\2*\s*)\n\s*\S.*\n\1$/
syn match todoTransition /\v%(\_^\s*\n)@<=\_^[=`:.'"~^_*+#-]{4,}\s*(\n\s*\_$)\@=/

syn match todoComment /\v#.*$/

syn match todoHigher /\v\(1\).+/
syn match todoHigh /\v\(2\).+/
syn match todoMedium /\v\(3\).+/
syn match todoLow /\v\(4\).+/
syn match todoLower /\v\(5\).+/

syn match todoDoneIcon "g:todo_done" contained

let b:regesc = '[]()?.*@='

function! s:CreateMatch(name, regex)
  exec 'syn match ' . a:name . ' /\v' . a:regex . '/'
endfunction

call s:CreateMatch('todoWorkingIcon', escape(g:todo_working, b:regesc))
call s:CreateMatch('todoDoneIcon', escape(g:todo_done, b:regesc))
call s:CreateMatch('todoCancledIcon', escape(g:todo_cancled, b:regesc))
call s:CreateMatch('todoDoneItem', '(' . escape(g:todo_done, b:regesc) . ')@<=.*')
call s:CreateMatch('todoCancledItem', '(' . escape(g:todo_cancled, b:regesc) . ')@<=.*')

function! s:DefineOneInlineMarkup(name, start, middle, end, char_left, char_right)
  execute 'syn region todo' . a:name .
        \ ' start=+' . a:char_left . '\zs' . a:start .
        \ '\ze[^[:space:]' . a:char_right . a:start[strlen(a:start) - 1] . ']+' .
        \ a:middle .
        \ ' end=+\S' . a:end . '\ze\%($\|\s\|[''"’)\]}>/:.,;!?\\-]\)+'
endfunction

function! s:DefineInlineMarkup(name, start, middle, end)
  let middle = a:middle != "" ?
        \ (' skip=+\\\\\|\\' . a:middle . '+') :
        \ ""

  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, "'", "'")
  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '"', '"')
  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '(', ')')
  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '\[', '\]')
  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '{', '}')
  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '<', '>')
  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '’', '’')
  " TODO: Additional Unicode Pd, Po, Pi, Pf, Ps characters

  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '\%(^\|\s\|[/:]\)', '')

  execute 'syn match todo' . a:name .
        \ ' +\%(^\|\s\|[''"([{</:]\)\zs' . a:start .
        \ '[^[:space:]' . a:start[strlen(a:start) - 1] . ']'
        \ a:end . '\ze\%($\|\s\|[''")\]}>/:.,;!?\\-]\)+'

  execute 'hi def link todo' . a:name . 'Delimiter' . ' todo' . a:name
endfunction

call s:DefineInlineMarkup('Emphasis', '\*', '\*', '\*')
call s:DefineInlineMarkup('StrongEmphasis', '\*\*', '\*', '\*\*')

hi def link todoSection Title
hi def link todoTransition todoSection
hi def link todoComment Comment

hi def todoHigher ctermfg=1
hi def todoHigh ctermfg=9
hi def todoMedium ctermfg=3
hi def todoLow ctermfg=2
hi def todoLower ctermfg=4

hi def todoEmphasis term=italic cterm=italic gui=italic
hi def todoStrongEmphasis term=bold cterm=bold gui=bold

hi def link todoDoneItem Comment
hi def link todoCancledItem Comment

hi def link todoWorkingIcon Comment
hi def todoDoneIcon ctermfg=2
hi def todoCancledIcon ctermfg=1


let b:current_syntax = "todo"
