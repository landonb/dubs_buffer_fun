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
" silent! unlet g:plugin_dubs_buffer_fun_list_buffers_and_prompt

if exists('g:plugin_dubs_buffer_fun_list_buffers_and_prompt') || &cp || v:version < 700
  finish
endif
let g:plugin_dubs_buffer_fun_list_buffers_and_prompt = 1

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" --------------------------------------------------------
" List Buffers and Prompt for Buffer Number — The Easy Way
" --------------------------------------------------------

" Tip from http://eseth.org/2007/vim-buffers.html
" Show buffer list and prompt for buffer number or
" (partial) name.
nnoremap <S-F2> :ls<CR>:b<Space>
" Caveat: Resets to normal mode:
inoremap <S-F2> <ESC>:ls<CR>:b<Space>

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" ---------------------------------------------------------
" Simple Buffer Switcher Prompt — The Slighly Less Easy Way
" ---------------------------------------------------------

" I tried minibufexpl, bufman, and bufferlist:
"   http://www.vim.org/scripts/script.php?script_id=159
"   http://www.vim.org/scripts/script.php?script_id=875
"   http://www.vim.org/scripts/script.php?script_id=1325
"   :(respectively)
" but this is simpl the best.
"
" SAVVY/2015-01-08: The built-in buffer list and :b prompt does
" essentially the same as this function. See Shift-F2, above,
" which calls :ls<CR>:b<Space>
" - So <__> and <S-F2> are effectively redundant.
"   - MAYBE/2024-03-04: Nix one of these.

function! s:SimplBuffrListr()
  " Show all buffers, one per line, in the
  " command-line window (which expands upward
  " as needed, and disappears when finished)
  " TODO I've never tested w/ more buffers than
  "      screen lines -- is there a More/Enter-to-
  "      Continue prompt?
  :buffers
  " Ask the user to enter a buffer by its number
  let i = input("Buffer number: ")
  " Check for <ESC> lest we dismiss a help
  " page (or something not in the buffer list)
  if i != ""
   execute "buffer " . i
  endif
endfunction

" Map a double-underscore to the simpl(e)
" buffe(r) liste(r)
" EXPLAIN/2017-03-28: function defined as s:SimplBuffrListr,
"                                  not as <SID>SimplBuffrListr,
"                                  so how does this work?
map <silent> __ :call <SID>SimplBuffrListr()<CR>
" NOTE to the wise: tabs? tabs?! who needs tabs!!?
"      buflists? buflists?! who needs buflists!!?
"      serlussly, pound a double-underscore every
"      once 'n a while, but keep yer doc names
"      outta me face. #foccers

