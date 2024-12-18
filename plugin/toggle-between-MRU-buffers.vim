" vim:tw=0:ts=2:sw=2:et:norl:
" Author: Landon Bouma <https://tallybark.com/> 
" Project: https://github.com/embrace-vim/vim-buffer-delights#🍧
" License: vim-buffer-delights by Landon Bouma is marked with CC0 1.0
"   https://creativecommons.org/publicdomain/zero/1.0/
"   Copyright © 2009, 2015, 2017, 2024 Landon Bouma.

" -------------------------------------------------------------------

" USAGE: Unlet var (or nix finish) & press <F9> to reload this plugin.
" USING: https://github.com/landonb/vim-source-reloader#↩️
"
"  silent! unlet g:plugin_dubs_buffer_fun_toggle_between_mru

if exists('g:plugin_dubs_buffer_fun_toggle_between_mru') || &cp || v:version < 700

  finish
endif

let g:plugin_dubs_buffer_fun_toggle_between_mru = 1

" -------------------------------------------------------------------

if exists('g:vim_buffer_delights_disable') && g:vim_buffer_delights_disable

  finish
endif

" -------------------------------------------------------------------

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
"   :help CTRL-6
"   :help CTRL-^*
"   - It is equivalent to `:e #`, except that it also
"     works when there is no file name.
"
" But here we bake our own approach, to deal with
" special buffers properly.

function! s:Switch_MRU_Safe()
  " Check the current buffer for normality.
  if !g:embrace#windows#IsNormalBuffer('%')
    echomsg "No MRU for special buffer."
  " The special '#' is what Vim calls the alternate-file.
  elseif (expand('#') != '')
    " Check the alternate buffer for normality.
    if !g:embrace#windows#IsNormalBuffer('#')
      echomsg "MRU is a special buffer; cannot switch."
    else
      execute "edit #"
    endif
  else
    echomsg "No MRU yet."
  endif
endfunction

" -------------------------------------------------------------------

" Enable hidden, in case user is viewing modified buffer. This
" lets us hide modified buffer without Vim emitting a warning.
set hidden

nnoremap <F2> :call <SID>Switch_MRU_Safe()<CR>
inoremap <F2> <C-O>:call <SID>Switch_MRU_Safe()<CR>

