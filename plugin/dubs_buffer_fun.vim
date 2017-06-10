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
if v:version < 700 || exists('plugin_dubs_buffer_fun') || &cp
  finish
endif
let plugin_dubs_buffer_fun = 1

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Buffer-related Commands
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
function s:Switch_MRU_Safe()
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

" Tip from http://eseth.org/2007/vim-buffers.html
" Show buffer list and prompt for buffer number or
" (partial) name.
nnoremap <S-F2> :ls<CR>:b<Space>
" Caveat: Resets to normal mode:
inoremap <S-F2> <ESC>:ls<CR>:b<Space>

" Allow toggling between MRU buffers
" from Insert mode
" FIXME 2011.01.17 I never use these keys
" FIXME 2012.06.26 I just tested selecting text and hitting Ctrl-6 and the
"       screen only blipped at me but I didn't change buffers like F2.
" FIXME: Broken 'til fixed!
"inoremap <C-^> <C-O>:e #<CR>
"noremap <C-6> <C-O>:e #<CR>
"" cnoremap <F12> <C-C>:e #!<CR>
"" onoremap <F12> <C-C>:e #<CR>

" 2011.01.17 On my laptop, I've got Browser Fwd
"            mapped to <End> in ~/.xmodmap.
"            (Browser Fwd is just above <Right>)
"            Since Browser back is a special key,
"            too (delete), and since I use F12 a lot,
"            I figured I'd map the MRU buffer to
"            Alt-End, as well, so I can find hit when
"            I'm on the bottoms of my keyboard.
" I've got two available keys: M-BrwLeft and BrwRight
" (Really, M-BrwLeft is M-Delete, and BrwRight is End)
" I think I'll remap BrwRight to F12 instead of End...
"map <M-End> :e #<CR>
"inoremap <M-End> <C-O>:e #<CR>

" ------------------------------------------------------
" Simple Buffer Switcher Prompt
" ------------------------------------------------------

" I tried minibufexpl, bufman, and bufferlist:
"   http://www.vim.org/scripts/script.php?script_id=159
"   http://www.vim.org/scripts/script.php?script_id=875
"   http://www.vim.org/scripts/script.php?script_id=1325
"   :(respectively)
" but this is simpl the best.
" 2015.01.08: Actually, the built-in buffer list prompt is
" better. See Shift-F2, which is mapped to :ls<CR>:b<Space>

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

" Ctrl-Shift-Up/Down Jumps Windows
" --------------------------------

" This is Ctrl-Shift-Down to Next Window
noremap <C-S-Down> <C-W>w
inoremap <C-S-Down> <C-O><C-W>w
cnoremap <C-S-Down> <C-C><C-W>w
onoremap <C-S-Down> <C-C><C-W>w

" And this is Ctrl-Shift-Up to Previous Window
noremap <C-S-Up> <C-W>W
inoremap <C-S-Up> <C-O><C-W>W
cnoremap <C-S-Up> <C-C><C-W>W
onoremap <C-S-Up> <C-C><C-W>W

" Karma's an Itch
" --------------------------------
" We taketh, and we giveth.
" Re-map next and previous tab, since we
" took away Ctrl-PageUp/Down earlier.

" This is Alt-PageDown to Next Tab Page
" NOTE gt is the Normal mode shortcut
" 2012.06.26: [lb] Does anyone use Tabs ever?
noremap <M-PageDown> :tabn<CR>
inoremap <M-PageDown> <C-O>:tabn<CR>
cnoremap <M-PageDown> <C-C>:tabn<CR>
onoremap <M-PageDown> <C-C>:tabn<CR>

" This is Alt-PageUp to Previous Tab Page
" NOTE gT is the Normal mode shortcut
noremap <M-PageUp> :tabN<CR>
inoremap <M-PageUp> <C-O>:tabN<CR>
cnoremap <M-PageUp> <C-C>:tabN<CR>
onoremap <M-PageUp> <C-C>:tabN<CR>

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Mini Buffer Explorer Shortcut
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Alt-Shift-2 // Toggle Mini Buffer Explorer
" --------------------------------
" First, configure MiniBufExplorer
" to show up just above the status line
" (at the bottom of the gVim window,
"  rather than at the top)
let g:miniBufExplSplitBelow = 1
" The next variable causes MiniBufExplorer to
" auto-load when N eligible buffers are visible;
" this is distracting in Gvim, so I set it to
" 1 to auto-open at first, but this also doesn't
" work well from the command line with just Vim,
" so we check our environment first
if has("gui_running")
  let g:miniBufExplorerMoreThanOne = 1
else
  let g:miniBufExplorerMoreThanOne = 2
endif
" Instead of double-click, single-click to switch to buffer
let g:miniBufExplUseSingleClick = 1
" Start w/ minibufexpl off
" TODO BROKEN It starts with Command-line Vim, whaddup...?
"      (Meaning you gotta :q twice to exit, since the first
"       :q just closes the MiniBufExpl window)
let s:MiniBufExplPath = ""
"" NOTE I can't find any other place this is used, but
""      set MiniBufExplLoaded to -1 so MBE loads for gVim
""      but not for terminal Vim (tVim?)
"let s:MiniBufExplLoaded = -1
let s:MiniBufExplFile = "minibufexpl.vim"
let s:mbef = findfile(s:MiniBufExplFile,
                      \ pathogen#split(&rtp)[0] . "/**")
if s:mbef != ''
  " Turn into a full path. See :h filename-modifiers
  let s:MiniBufExplPath = fnamemodify(s:mbef, ":p")
elseif filereadable($HOME . "/.vim/plugin/"
                \ . s:MiniBufExplFile)
  " $HOME/.vim is just *nix
  let s:MiniBufExplPath = $HOME
                          \ . "/.vim/plugin/"
                          \ . s:MiniBufExplFile
elseif filereadable($USERPROFILE
                    \ . "/vimfiles/plugin/"
                    \ . s:MiniBufExplFile)
  " $HOME/vimfiles is just Windows
  let s:MiniBufExplPath = $USERPROFILE
                          \ . "/vimfiles/plugin/"
                          \ . s:MiniBufExplFile
"elseif
  " TODO What about Mac? Probably just
  "      like *nix, right?
elseif filereadable($VIMRUNTIME
                    \ . "/plugin/"
                    \ . s:MiniBufExplFile)
  " $VIMRUNTIME works for both *nix and Windows
  let s:MiniBufExplPath = $VIMRUNTIME
                          \ . "/plugin/"
                          \ . s:MiniBufExplFile
endif
if s:MiniBufExplPath != ''
  execute "source " . s:MiniBufExplPath
else
  "call confirm('Dubs: Cannot find MiniBuf Explorer', 'OK')
endif
" 2015.01.15: Deprecated: CMiniBufExplorer, replaced by MBEClose.
autocmd VimEnter * nested
    \ let greatest_buf_no = bufnr('$') |
    \ if (greatest_buf_no == 1)
    \     && (bufname(1) == "") |
    \   execute "MBEClose" |
    \ endif

" New 2011.01.13: Smart toggle. If you don't do this and your Quickfix window
" is open, toggling the minibuf window will make the Quickfix window taller.
"   The old way:
""     nmap <M-@> <Plug>TMiniBufExplorer
""     imap <M-@> <C-O><Plug>TMiniBufExplorer
"     nmap <M-@> <Plug>MBEToggle
"     imap <M-@> <C-O><Plug>MBEToggle
"     "cmap <M-&> <C-C><Plug>DubsHtmlEntities_ToggleLookup<ESC>
"     "omap <M-&> <C-C><Plug>DubsHtmlEntities_ToggleLookup<ESC>

" SYNC_ME: Dubsacks' <M-????> mappings are spread across plugins. [M-S-2]
"nmap <M-@> :call ToggleMiniBufExplorer()<CR>
"imap <M-@> <C-O>:call ToggleMiniBufExplorer()<CR>
nmap <M-@> :ToggleMiniBufExplorer<CR>
imap <M-@> <C-O>:ToggleMiniBufExplorer<CR>

" FIXME Toggling minibufexplorer in insert mode marks current buffer dirty
"       2011.01.18 I noticed this yesterday but today I'm not seeing it...

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Application Window Resizing Commands
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" ------------------------------------------------------
" Fullscreen
" ------------------------------------------------------

" This is such a hack! Just set lines and columns
" to ridiculous numbers.
" See dubsacks.vim, which inits cols,ll to 111,44
" FIXME 111,44 magic numbers, also shared w/ dubsacks.vim
" SYNC_ME: Dubsacks' <M-????> mappings are spread across plugins. [M-S-4]
""nmap <silent> <M-$> <Plug>DubsBufferFun_ToggleFullscreen_Hack
""imap <silent> <M-$> <C-O><Plug>DubsBufferFun_ToggleFullscreen_Hack
" 2011.05.20: Disabling. It sucks at what it does.
"map <F11> <Plug>DubsBufferFun_ToggleFullscreen_Hack

" FIXME I don't use this fcn.: it's not very elegant. I just
"       double-click the titlebar instead and let Gnome handle it...

" 2017-03-28: Can I/Should I use the !hasmapto paradigm here?
"?if !hasmapto('<Plug>DubsBufferFun_ToggleFullscreen_Hack')
"?  map <silent> <unique> ???????
"?    \ <Plug>DubsStyleGuard_CycleThruStyleGuides
"?endif
map <silent> <unique> <script>
  \ <Plug>DubsBufferFun_ToggleFullscreen_Hack
  \ :call <SID>ToggleFullscreen_Hack()<CR>

"   2. Thunk the <Plug>
function s:ToggleFullscreen_Hack()
  if exists('s:is_fullscreentoggled')
      \ && (1 == s:is_fullscreentoggled)
    set columns=111 lines=44
    let s:is_fullscreentoggled = 0
  else
    " FIXME This causes weird scrolling phenomenon
    set columns=999 lines=999
    " FIXME Do this instead in Windows?
    " au GUIEnter * simalt ~x
    let s:is_fullscreentoggled = 1
  endif
endfunction
let s:is_fullscreentoggled = 0

" ------------------------------------------------------
" Some lame smart-maximize command I don't use...
" ------------------------------------------------------

" ============== DEPRECATED

" Remap ,m to make and open error window if there are any errors. If there
" weren't any errors, the current window is maximized.
"map <silent> ,m :mak<CR><CR>:cw<CR>:call MaximizeIfNotQuickfix()<CR>

" Maximizes the current window if it is not the quickfix window.
function MaximizeIfNotQuickfix()
  if (getbufvar(winbufnr(winnr()), "&buftype") != "quickfix")
    wincmd _
  endif
endfunction

" ------------------------------------------------------
" Another silly smart-resize command I don't use...
" ------------------------------------------------------
" http://vim.wikia.com/wiki/Always_keep_quickfix_window_at_specified_height

" ============== DEPRECATED

" Maximize the window after entering it, be sure to keep the quickfix window
" at the specified height.
"au WinEnter * call MaximizeAndResizeQuickfix(12)

" Maximize current window and set the quickfix window to the specified height.
function MaximizeAndResizeQuickfix(quickfixHeight)
  " Redraw after executing the function.
  let s:restore_lazyredraw = getbufvar("%", "&lazyredraw")
  set lazyredraw
  " Ignore WinEnter events for now.
  "let s:restore_eventignore = getbufvar("%", "&ei")
  set ei=WinEnter
  " Maximize current window.
  wincmd _
  " If the current window is the quickfix window
  if (getbufvar(winbufnr(winnr()), "&buftype") == "quickfix")
    " Maximize previous window, and resize the quickfix window to the
    " specified height.
    wincmd p
    resize
    wincmd p
    exe "resize " . a:quickfixHeight
  else
    " Current window isn't the quickfix window, loop over all windows to
    " find it (if it exists...)
    let i = 1
    let cur_bufbr = winbufnr(i)
    while (cur_bufbr != -1)
      " If the buffer in window i is the quickfix buffer.
      if (getbufvar(cur_bufbr, "&buftype") == "quickfix")
        " Go to the quickfix window, set height to quickfixHeight, and jump to
        " the previous window.
        exe i . "wincmd w"
        exe "resize " . a:quickfixHeight
        wincmd p
        break
      endif
      let i = i + 1
      let cur_bufbr = winbufnr(i)
    endwhile
  endif
  "set nolazyredraw
  set ei-=WinEnter
  if (!s:restore_lazyredraw)
    set nolazyredraw
  endif
  " this isn't working...
  "set ei=s:restore_eventignore
endfunction

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" MiniBufExplorer...
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" MAYBE: I had edited the 6.3.3 minibufexpl source to react to
"        double-click in insert mode, e.g.,
"   " 2011.01.19: [lb] Make double-click work when in Insert mode
"   inoremap <buffer> <2-LEFTMOUSE> <C-O>:call <SID>MBEDoubleClick()<CR>
"        but a similar change to the 6.5.0 source does not work:
"        double-click merely starts selecting text in the minibufexpl.
"   inoremap <buffer> <2-LEFTMOUSE> <C-O>:call <SID>MBESelectBuffer(0)<CR><C-O>:<BS>
"        Oh, well, it's not like I really use minibufexplorer anymore.

