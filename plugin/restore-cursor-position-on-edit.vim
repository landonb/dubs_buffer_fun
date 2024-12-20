" vim:tw=0:ts=2:sw=2:et:norl:
" Author: Landon Bouma <https://tallybark.com/> 
" Project: https://github.com/embrace-vim/vim-buffer-delights#🍧
" License: vim-buffer-delights by Landon Bouma is marked with CC0 1.0
"   https://creativecommons.org/publicdomain/zero/1.0/
"   Copyright © 2009, 2015, 2017, 2024 Landon Bouma.

" -------------------------------------------------------------------

" GUARD: Press <F9> to reload this plugin (or :source it).
" - Via: https://github.com/landonb/vim-source-reloader#↩️

if expand("%:p") ==# expand("<sfile>:p")
  unlet g:loaded_vim_buffer_delights_restore_cursor_position
endif

if exists("g:loaded_vim_buffer_delights_restore_cursor_position") || &cp

  finish
endif

let g:loaded_vim_buffer_delights_restore_cursor_position = 1

" -------------------------------------------------------------------

if exists('g:vim_buffer_delights_disable') && g:vim_buffer_delights_disable

  finish
endif

" -------------------------------------------------------------------

" ------------------------------------------------------
" Jump to Last Known Cursor Position
" ------------------------------------------------------

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

