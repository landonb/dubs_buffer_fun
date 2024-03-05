" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Project Page: https://github.com/landonb/dubs_buffer_fun
" License: GPLv3
" vim:tw=0:ts=2:sw=2:et:norl:
" -------------------------------------------------------------------
" Copyright © 2009, 2015, 2017, 2024 Landon Bouma.

" ------------------------------------------
" Startguard:

" Only load if not prev. loaded, if is more
" Vi-compatible, and Vim at least version 7.
"
" YOU: Uncomment next 'unlet', then <F9> to reload this file.
"      (Iff: https://github.com/landonb/vim-source-reloader)
"
" silent! unlet g:plugin_dubs_buffer_fun_buffer_delete

if exists('g:plugin_dubs_buffer_fun_buffer_delete') || &cp || v:version < 700
  finish
endif
let g:plugin_dubs_buffer_fun_buffer_delete = 1

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" ------------------------------------------
" Window-Friendly Buffer Delete
" ------------------------------------------
" COPYD: And modified from 2008-11-18 version:
" - *Deleting a buffer without closing the window*
"   http://vim.wikia.com/wiki/VimTip165

" ***

" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" ***

" By default, allow the user to close a buffer
" even if it's being viewed in multiple windows.
" The user can :let g:plugin_bclose_multiple = 0
" in their Vim startup script to prevent this.
if !exists('g:plugin_bclose_multiple')
  let g:plugin_bclose_multiple = 1
endif

" ***

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)
  if empty(a:buffer)
    let btarget = bufnr('%')
  elseif a:buffer =~ '^\d\+$'
    let btarget = bufnr(str2nr(a:buffer))
  else
    let btarget = bufnr(a:buffer)
  endif
  if btarget < 0
    call s:Warn('No matching buffer for '.a:buffer)
    return
  endif
  if empty(a:bang) && getbufvar(btarget, '&modified')
    call s:Warn('No write since last change for buffer '
      \ . btarget . ' (use :Bclose!)')
    " [Confirm-tip] Comment this out if you want confirmation (see below)
    " [lb] 2009.09.05
    "return
  endif
  " Numbers of windows that view target buffer which we will delete.
  let wnums = filter(range(1, winnr('$')),
    \ 'winbufnr(v:val) == btarget')
  if !g:plugin_bclose_multiple && len(wnums) > 1
    call s:Warn('Buffer is in multiple windows '
      \ . '(use ":let plugin_bclose_multiple=1")')
    return
  endif
  let wcurrent = winnr()
  for w in wnums
    execute w.'wincmd w'
    let prevbuf = bufnr('#')
    if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
      buffer #
    else
      bprevious
    endif
    if btarget == bufnr('%')
      " Numbers of listed buffers which are not the target to be deleted.
      let blisted = filter(range(1, bufnr('$')),
        \ 'buflisted(v:val) && v:val != btarget')
      " Listed, not target, and not displayed.
      let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
      " Take the first buffer, if any (could be more intelligent).
      let bjump = (bhidden + blisted + [-1])[0]
      if bjump > 0
        execute 'buffer '.bjump
      else
        execute 'enew'.a:bang
      endif
    endif
  endfor
  "execute 'bdelete'.a:bang.' '.btarget
  " [Confirm-tip] Un-comment this out if you want confirmation (see above)
  " [lb] 2009.09.05 -- and don't forget to comment out bdelete just above
  execute ':confirm :bdelete '.btarget
  execute wcurrent.'wincmd w'
endfunction

" ***

" Make a command alias named simply 'Bclose'
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose('<bang>', '<args>')

" Also make a shortcut at \bd
nnoremap <silent> <Leader>bd :Bclose<CR>

