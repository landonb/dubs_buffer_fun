" vim:tw=0:ts=2:sw=2:et:norl:
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/embrace-vim/vim-buffer-delights#🍧
" License: vim-buffer-delights by Landon Bouma is marked with CC0 1.0
"   https://creativecommons.org/publicdomain/zero/1.0/
"   Copyright © 2024-2025 Landon Bouma.

" -------------------------------------------------------------------

" GUARD: Press <F9> to reload this plugin (or :source it).
" - Via: https://github.com/embrace-vim/vim-source-reloader#↩️

if expand('%:p') ==# expand('<sfile>:p')
  unlet! g:loaded_vim_buffer_delights_scratch_buffer
endif

if exists('g:loaded_vim_buffer_delights_scratch_buffer') || &cp

  finish
endif

let g:loaded_vim_buffer_delights_scratch_buffer = 1

" -------------------------------------------------------------------

if get(g:, 'vim_buffer_delights_disable', 0)

  finish
endif

" -------------------------------------------------------------------

command! -nargs=* Scratch call g:embrace#scratch#CreateScratchWindow()

