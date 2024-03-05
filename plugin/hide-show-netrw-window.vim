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
" silent! unlet g:plugin_dubs_buffer_fun_hide_show_netrw_window

if exists('g:plugin_dubs_buffer_fun_hide_show_netrw_window') || &cp || v:version < 700
  finish
endif
let g:plugin_dubs_buffer_fun_hide_show_netrw_window = 1

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" ------------------------------------------------------
" Toggle :netrw window
" ------------------------------------------------------

" Toggle :netrw window on <S-M-2> aka <M-@>.
" - FIXME/2024-03-04: When used twice, to open then close netrw, when
"   netrw is closed, other windows are not resized properly. If project
"   tray is showing, it's widened, for some reason; if no project tray
"   and there are 2 vertical windows, after closing netrw, the 1st window
"   is enlarged to 66% width, and the 2nd window shrank to 33%.
" - MAYBE/2017-11-02: Add, e.g., Alt-Shift-F2 binding to always close netrw
"   window (and resize remaining windows equally, ignoring project tray).
"   - MAYBE: Use fullscreen plug:
"       ~/.vim/pack/landonb/start/dubs_buffer_fun/plugin/window-resize-fullscreen-toggle.vim

nmap <M-@> :Lexplore<CR>
imap <M-@> <C-O>:Lexplore<CR>

