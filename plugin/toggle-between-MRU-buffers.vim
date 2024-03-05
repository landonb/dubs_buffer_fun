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
" silent! unlet g:plugin_dubs_buffer_fun_toggle_between_mru

if exists('g:plugin_dubs_buffer_fun_toggle_between_mru') || &cp || v:version < 700
  finish
endif
let g:plugin_dubs_buffer_fun_toggle_between_mru = 1

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" ------------------------------------------------------
" MRU Buffer Jumping
" ------------------------------------------------------

" Vim has 2 built-in MRU buffer jumpers:
"
"   :help edit_#
"   - Edit the [count]th buffer (as shown by |:files|).
"     This command does the same as [count] CTRL-^. 
"     But `:e #` doesn't work if the alternate buffer doesn't
"     have a file name, while CTRL-^ still works then.
"
"   :help CTRL-^*
"   - It is equivalent to `:e #`, except that it also
"     works when there is no file name.
"
" But here we bake our own approach, to deal with
" special buffers properly.

function! s:Switch_MRU_Safe()
  " Check the current buffer for specialness.
  if ((&buflisted == 0)
      \ || (&buftype == 'quickfix')
      \ || (&modifiable == 0)
      \ || (bufname('%') == '-MiniBufExplorer-'))
    echomsg "No MRU for special buffer/window."
  " The special '#' is what Vim calls the alternate-file.
  elseif (expand('#') != '')
    " Check the alternate buffer for specialness.
    if ((buflisted(expand('#')) == 0)
        \ || (bufname(0) == '-MiniBufExplorer-'))
        " [lb] isn't sure of an easy way to get these settings for other buf.
        " \ || (&buftype == 'quickfix')
        " \ || (&modifiable == 0)
      echomsg "The MRU is a special buffer; cannot switch."
    else
      execute "edit #"
    endif
  else
    echomsg "No MRU yet."
  endif
endfunction

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Enable hidden, in case user is viewing modified buffer. This
" lets us hide modified buffer without Vim emitting a warning.
set hidden

nnoremap <F2> :call <SID>Switch_MRU_Safe()<CR>
inoremap <F2> <C-O>:call <SID>Switch_MRU_Safe()<CR>

