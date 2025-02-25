" vim:tw=0:ts=2:sw=2:et:norl:
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/embrace-vim/vim-buffer-delights#🍧
" License: GPLv3
" Copyright © 2024 Landon Bouma.

function! g:embrace#scratch#CreateLogWindow() abort
  if get(s:, 'bufnr', 0) > 0
    let l:logwin = bufwinnr(s:bufnr)

    if l:logwin > 0
      echom 'Closing win ' .. bufwinnr(s:bufnr)
      execute bufwinnr(s:bufnr) .. 'wincmd c'
    else
      echom 'Log window previously closed'
    endif

    let s:bufnr = -1
  endif

  let l:bufnr = g:embrace#scratch#CreateScratchWindow('log')

  let l:msg = 'Create new log window: ' .. l:bufnr

  echom l:msg

  let s:bufnr = l:bufnr

  " Appending now leaves first line blank. Weird?
  "  call g:embrace#scratch#AppendScratch([l:msg, "You're welcome!"])
  call setbufline(s:bufnr, 1, [l:msg, "  You're welcome!"])

  return l:bufnr
endfunction

function! g:embrace#scratch#CreateScratchWindow(type = '') abort
  let l:oldwin = winnr()

  let l:old_h = winheight(l:oldwin)

  if a:type == 'log'
    " Move cursor to bottom-right window.
    wincmd b

    below new
  else
    horizontal new
  endif

  let l:bufnr = bufnr()

  if a:type == 'log'
    wincmd J
    10wincmd _
    " See also |equalalways| and |CTRL-W_=|
    set winfixheight
  else
    execute str2nr(l:old_h / 3) .. 'wincmd _'
  endif

  call g:embrace#scratch#SetupScratchBuffer()

  " Don't name it, which would create a path for it
  " (though won't write to it until you :write).
  "  file event.log

  " Return to previous window.
  " - Nope. Might be second-to-last window b/c
  "   wincmd's above.
  "  wincmd p
  execute l:oldwin .. 'wincmd w'

  return l:bufnr
endfunction

" SAVVY: When you :bd a buffer, Vim refers to it as [No Name] in the
"   titlebar (though expand('%:p') returns empty string).
"   - After buftype=nofile, the title changes to [Scratch].
"   - But not when --noplugin — I think it's titlestring=%t that does it
"     (Vim returns [Scratch] for the "File name (tail)".
"        |statusline| |titlestring|
"      ~/.kit/nvim/landonb/vim-title-bar-time-of-day/plugin/title_bar_time_of_day.vim
" ALTLY:
"   " :wincmd b
"   "   \ | below new
"   "   \ | wincmd J
"   "   \ | 10wincmd _
"   "   \ | setlocal modifiable buftype=nofile bufhidden=hide noswapfile nobuflisted
"   " :h special-buffers
"   " :h put
"   " :h :w
"   " :h :file
"   " :h <mods>
"   command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
" REFER: |scratch-buffer|
" USYNC: See similar fcn. in project tray project.
function! g:embrace#scratch#SetupScratchBuffer() abort
  set modifiable
  setlocal buftype=nofile
  " setlocal bufhidden=hide
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal nobuflisted
  " setlocal readonly
endfunction

function! g:embrace#scratch#AppendScratch(msgs) abort
  let l:logwin = g:embrace#scratch#ScratchWinnr()

  if l:logwin < 1

    return
  endif

  " Nope!
  "  call writefile(['foo', 'bar'], 'event.log', 'a')
  call appendbufline(s:bufnr, '$', a:msgs)

  let l:curwin = winnr()

  if l:curwin != l:logwin
    let l:use_win_execute = 1
    let l:use_windo = 0

    if l:use_win_execute
      " Yay! This is quicker than `windo` and using `wincmd w`
      " because it doesn't move the cursor.
      " - REFER: See also :h winid
      call win_execute(win_getid(bufwinnr(s:bufnr)), "normal! Gzz")
    elseif l:use_windo
      " Interestingly, :windo moves the cursor:
      execute bufwinnr(s:bufnr) .. "windo execute '$'"
      execute l:curwin .. 'wincmd w'
    else
        " So we'll it the long way.
      execute bufwinnr(s:bufnr) .. 'wincmd w'
      execute '$'
      " Maybe center? We'll try it.
      normal zz
      execute l:curwin .. 'wincmd w'
    endif
  endif
endfunction

function! g:embrace#scratch#ScratchWinnr() abort
  if get(s:, 'bufnr', 0) < 1
    " echom "No log window / Please call g:embrace#scratch#CreateLogWindow()"

    return -1
  endif

  let l:logwin = bufwinnr(s:bufnr)

  if l:logwin < 1
    let s:bufnr = -1

    echom 'Log window has closed'

    return -1
  endif

  return l:logwin
endfunction

