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

" Map F12 to Ctrl-^, to toggle between the
" current buffer and the last used buffer.
" But first!
"   Turn on hidden, so if we're on a modified
"   buffer, we can hide it without getting a
"   warning
set hidden
" 2011.05.20: I don't use this for jumping buffers.
"             I use F2 and the pg-right key.
"map <F12> :e #<CR>
"inoremap <F12> <C-O>:e #<CR>
"" cnoremap <F12> <C-C>:e #!<CR>
"" onoremap <F12> <C-C>:e #<CR>

" My left hand felt left out, so I mapped Ftoo, 2.
" Note that when text is selected, F1 sends it to par.
"nnoremap <F2> :e #<CR>
"inoremap <F2> <C-O>:e #<CR>
nnoremap <F2> :call <SID>Switch_MRU_Safe()<CR>
inoremap <F2> <C-O>:call <SID>Switch_MRU_Safe()<CR>
"
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

