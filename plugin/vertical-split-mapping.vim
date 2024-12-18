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
"  silent! unlet g:loaded_vim_buffer_delights_vertical_split_mapping

if exists('g:loaded_vim_buffer_delights_vertical_split_mapping') || &cp || v:version < 700

  finish
endif

let g:loaded_vim_buffer_delights_vertical_split_mapping = 1

" -------------------------------------------------------------------

if exists('g:vim_buffer_delights_disable') && g:vim_buffer_delights_disable

  finish
endif

" -------------------------------------------------------------------

" ------------------------------------------------------
" Vertical-split shortcut
" ------------------------------------------------------

function s:DubsBufferFun_VerticalSplit_vv()
  " https://www.bugsnag.com/blog/tmux-and-vim
  " vv to generate new vertical split
  nnoremap <silent> vv <C-w>v
endfunction

call <SID>DubsBufferFun_VerticalSplit_vv()

