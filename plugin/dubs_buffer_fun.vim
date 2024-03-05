" File: dubs_buffer_fun.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Last Modified: 2017.12.19
" Project Page: https://github.com/landonb/dubs_buffer_fun
" Summary: Buffer and window navigation features, and ctags!
" License: GPLv3
" vim:tw=0:ts=2:sw=2:et:norl:
" -------------------------------------------------------------------
" Copyright © 2009, 2015, 2017, 2024 Landon Bouma.
"
" This file is part of Dubs Vim.
"
" Dubs Vim is free software: you can redistribute it and/or
" modify it under the terms of the GNU General Public License
" as published by the Free Software Foundation, either version
" 3 of the License, or (at your option) any later version.
"
" Dubs Vim is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty
" of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
" the GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with Dubs Vim. If not, see <http://www.gnu.org/licenses/>
" or write Free Software Foundation, Inc., 51 Franklin Street,
"                     Fifth Floor, Boston, MA 02110-1301, USA.
" ===================================================================

" ------------------------------------------
" Startguard:

" Only load if not prev. loaded, if is more
" Vi-compatible, and Vim at least version 7.
"
" YOU: Uncomment next 'unlet', then <F9> to reload this file.
"      (Iff: https://github.com/landonb/vim-source-reloader)
"
" silent! unlet g:plugin_dubs_buffer_fun

if exists('g:plugin_dubs_buffer_fun') || &cp || v:version < 700
  finish
endif
let g:plugin_dubs_buffer_fun = 1

" ***

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Buffer-related Commands
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" ------------------------------------------
" Window-Friendly Buffer Delete
" ------------------------------------------
" From http://vim.wikia.com/wiki/VimTip165

" The following is a modified version of the script
" detailed at http://vim.wikia.com/wiki/VimTip165,
" last updated 2008-11-18.

" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" By default, allow the user to close a buffer
" even if it's being viewed in multiple windows.
" The user can :let g:plugin_bclose_multiple = 0
" in their Vim startup script to prevent this.
if !exists('g:plugin_bclose_multiple')
  let g:plugin_bclose_multiple = 1
endif

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

" Make a command alias named simply 'Bclose'
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose('<bang>', '<args>')

" Also make a shortcut at \bd
nnoremap <silent> <Leader>bd :Bclose<CR>

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

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" ------------------------------------------------------
" Vertical-split shortcut
" ------------------------------------------------------

function s:DubsBufferFun_VerticalSplit_vv()
  " https://www.bugsnag.com/blog/tmux-and-vim
  " vv to generate new vertical split
  nnoremap <silent> vv <C-w>v
endfunction

call <SID>DubsBufferFun_VerticalSplit_vv()

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

