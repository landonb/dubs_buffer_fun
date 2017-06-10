" File: dubs_buffer_fun.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Last Modified: 2017.06.10
" Project Page: https://github.com/landonb/dubs_buffer_fun
" Summary: Buffer and window navigation features, and ctags!
" License: GPLv3
" vim:tw=0:ts=2:sw=2:et:norl:
" -------------------------------------------------------------------
" Copyright © 2009, 2015, 2017 Landon Bouma.
"
" This file is part of Dubsacks.
"
" Dubsacks is free software: you can redistribute it and/or
" modify it under the terms of the GNU General Public License
" as published by the Free Software Foundation, either version
" 3 of the License, or (at your option) any later version.
"
" Dubsacks is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty
" of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
" the GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with Dubsacks. If not, see <http://www.gnu.org/licenses/>
" or write Free Software Foundation, Inc., 51 Franklin Street,
"                     Fifth Floor, Boston, MA 02110-1301, USA.
" ===================================================================

" ------------------------------------------
" Startguard:

" Only load if Vim is at least version 7 and
" if the script has not already been loaded
if v:version < 700 || exists('after_dubs_buffer_fun') || &cp
  finish
endif
let after_dubs_buffer_fun = 1

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Switching Buffers/Windows/Tabs
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Ctrl-Tab is for Tabs, Silly... no wait, Buffers!
" --------------------------------
" mswin.vim maps Ctrl-Tab to Next Window. To be
" more consistent with Windows (the OS), Ctrl-Tab
" should map to Next Tab... but in this case, I'm
" going to deviate from the norm and ask that you
" tab-holders-onners let go and try thinking in
" terms of buffers. It's all about the buffers,
" benjamin! (baby?)

" TODO The cursor is not preserved between
"      buffers! So make code that restores
"      the cursor...

" This is Ctrl-Tab to Next Buffer
"noremap <C-Tab> :bn<CR>
"inoremap <C-Tab> <C-O>:bn<CR>
""cnoremap <C-Tab> <C-C>:bn<CR>
"onoremap <C-Tab> <C-C>:bn<CR>
"snoremap <C-Tab> <C-C>:bn<CR>
" 2017-06-10: C-S-Tab works, but C-Tab overridden by `behave mswin`.
"   So making these mappings an 'after' thought.
noremap <C-Tab> :call <SID>BufNext_SkipSpecialBufs(1)<CR>
inoremap <C-Tab> <C-O>:call <SID>BufNext_SkipSpecialBufs(1)<CR>
"cnoremap <C-Tab> <C-C>:call <SID>BufNext_SkipSpecialBufs(1)<CR>
onoremap <C-Tab> <C-C>:call <SID>BufNext_SkipSpecialBufs(1)<CR>
snoremap <C-Tab> <C-C>:call <SID>BufNext_SkipSpecialBufs(1)<CR>

" This is Ctrl-Shift-Tab to Previous Buffer
"noremap <C-S-Tab> :bN<CR>
"inoremap <C-S-Tab> <C-O>:bN<CR>
""cnoremap <C-S-Tab> <C-C>:bN<CR>
"onoremap <C-S-Tab> <C-C>:bN<CR>
"snoremap <C-S-Tab> <C-C>:bN<CR>
noremap <C-S-Tab> :call <SID>BufNext_SkipSpecialBufs(-1)<CR>
inoremap <C-S-Tab> <C-O>:call <SID>BufNext_SkipSpecialBufs(-1)<CR>
"cnoremap <C-S-Tab> <C-C>:call <SID>BufNext_SkipSpecialBufs(-1)<CR>
onoremap <C-S-Tab> <C-C>:call <SID>BufNext_SkipSpecialBufs(-1)<CR>
snoremap <C-S-Tab> <C-C>:call <SID>BufNext_SkipSpecialBufs(-1)<CR>

"map <silent> <unique> <script>
"  \ <Plug>DubsBufferFun_BufNextNormal
"  \ :call <SID>BufNext_SkipSpecialBufs(1)<CR>
"map <silent> <unique> <script>
"  \ <Plug>DubsBufferFun_BufPrevNormal
"  \ :call <SID>BufNext_SkipSpecialBufs(-1)<CR>
""   2. Thunk the <Plug>
function s:BufNext_SkipSpecialBufs(direction)
  let start_bufnr = bufnr("%")
  let done = 0
  while done == 0
    if 1 == a:direction
      execute "bn"
    elseif -1 == a:direction
      execute "bN"
    endif
    let n = bufnr("%")
    "echo "n = ".n." / start_bufnr = ".start_bufnr." / buftype = ".getbufvar(n, "&buftype")
    "if (getbufvar(n, "&buftype") == "")
    "    echo "TRUE"
    "endif
     " Just 1 buffer or none are editable
    "if (start_bufnr == n)
    "      \ || ( (getbufvar(n, "&buftype") == "")
    "        \   && ( ((getbufvar(n, "&filetype") != "")
    "        \       && (getbufvar(n, "&fileencoding") != ""))
    "        \     || (getbufvar(n, "&modified") == 1)))
" FIXME Diff against previous impl
" FIXME Doesn't switch to .txt --> so set filetype for *.txt? another way?
    if (start_bufnr == n)
        \ || (getbufvar(n, "&modified") == 1)
        \ || ( (getbufvar(n, "&buftype") == "")
        \   && ((getbufvar(n, "&filetype") != "")
        \     || (getbufvar(n, "&fileencoding") != "")) )
      " (start_bufnr == n) means just 1 buffer or no candidates found
      " (buftype == "") means not quickfix, help, etc., buffer
      " NOTE My .txt files don't have a filetype...
      " (filetype != "" && fileencoding != "") means not a new buffer
      " (modified == "modified") means we don't skip dirty new buffers
      " HACK Make sure previous buffer works
      execute start_bufnr."buffer"
      execute n."buffer"
      let done = 1
    endif
  endwhile
endfunction

" NOTE Change :bn to :tabn and :bN to :tabN
"      if you'd rather have your tabs back

" ------------------------------------------------------
" Ctrl-J/Ctrl-K Traverse Buffer History
" ------------------------------------------------------
noremap <C-j> :BufSurfBack<CR>
inoremap <C-j> <C-O>:BufSurfBack<CR>
cnoremap <C-j> <C-C>:BufSurfBack<CR>
onoremap <C-j> <C-C>:BufSurfBack<CR>
"
" 2017-06-10: Fix <Ctrl-k>...
noremap <C-k> :BufSurfForward<CR>
" 2017-06-06: Don't touch <C-k>, so digraph insertion works...
"inoremap <C-k> <C-O>:BufSurfForward<CR>
cnoremap <C-k> <C-C>:BufSurfForward<CR>
onoremap <C-k> <C-C>:BufSurfForward<CR>
" <Ctrl-l> [is a Dubs command that] swaps two paragraphs. Which I don't use...
noremap <C-l> :BufSurfForward<CR>
inoremap <C-l> <C-O>:BufSurfForward<CR>
cnoremap <C-l> <C-C>:BufSurfForward<CR>
onoremap <C-l> <C-C>:BufSurfForward<CR>

