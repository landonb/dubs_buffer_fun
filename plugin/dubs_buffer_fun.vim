" File: dubs_buffer_fun.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Last Modified: 2017.12.19
" Project Page: https://github.com/landonb/dubs_buffer_fun
" Summary: Buffer and window navigation features, and ctags!
" License: GPLv3
" vim:tw=0:ts=2:sw=2:et:norl:
" -------------------------------------------------------------------
" Copyright © 2009, 2015, 2017 Landon Bouma.
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

" Change Window Focus Key Bindings
" --------------------------------

" Comparing the vim-tmux-navigator functions and Dubs Vim's JumpWindow:
" - The TmuxNavigate* functions call `wincmd <arg>`, which is just like
"   executing Ctrl-W <arg> (what JumpWindow calls).
" - The TmuxNavigate* functions use the wincmd vim-like direction arguments,
"   e.g., h|j|k|l, but JumpWindow uses the two w|W rotation-like clockwise/
"   counter-clockwise arguments.
" - As a consequence, there's slightly different behavior, e.g., consider
"   two vertically-split panes above a horizontally-split quickfix. From
"   the quickfix window, a wincmd-k (top) will move to the top pane on the
"   left, but a wincmd-W will move to the top pane on the right. And then
"   once the cursor is in one of the top panes, a wincmd-k will not have an
"   effect, but a wincmd-W will keep cycling the cursor between the panes.
"
" 2020-02-08: Here's the original, pre-vim-tmux-navigator functionality:
"
"   let s:was_insert_mode = 0
"   function! s:JumpWindow(where, was_insert_mode)
"     let l:was_quickfix = 0
"     if &ft == 'qf'
"       let l:was_quickfix = 1
"     else
"       let s:was_insert_mode = a:was_insert_mode
"     endif
"     execute "normal! \<C-W>" . a:where
"     if &ft == 'qf'
"       stopinsert
"     elseif l:was_quickfix == 1 && s:was_insert_mode == 1
"       startinsert
"     endif
"   endfunction
"
"   function! s:wire_keys_jump_to_window_previous_and_next()
"     " This is Ctrl-Shift-Down to Next Window
"     nnoremap <C-S-Down> :call <SID>JumpWindow('w', 0)<CR>
"     inoremap <C-S-Down> <C-O>:call <SID>JumpWindow('w', 1)<CR>
"     cnoremap <C-S-Down> <C-C><C-W>w
"     onoremap <C-S-Down> <C-C><C-W>w
"     " And this is Ctrl-Shift-Up to Previous Window
"     nnoremap <C-S-Up> :call <SID>JumpWindow('W', 0)<CR>
"     inoremap <C-S-Up> <C-O>:call <SID>JumpWindow('W', 1)<CR>
"     cnoremap <C-S-Up> <C-C><C-W>W
"     onoremap <C-S-Up> <C-C><C-W>W
"   endfunction
"
" And here's the simpler, tmux-aware functionality:
"
function! s:wire_keys_jump_to_window_directionally()

  " Tell vim-tmux-navigator not to create any key bindings.
  let g:tmux_navigator_no_mappings = 1

  " Note that many developers map pane navigation to
  " either Ctrl-h|j|k|l, or to Alt-left/-down/-right/-up,
  " but not me. I like to use Alt-arrows, but with a twist.

  " Alt-Up/-Down should be intuitive: Switch focus to pane -above/-below.

  nnoremap <silent> <M-Up> :TmuxNavigateUp<cr>
  inoremap <silent> <M-Up> <C-O>:TmuxNavigateUp<cr>

  nnoremap <silent> <M-Down> :TmuxNavigateDown<cr>
  inoremap <silent> <M-Down> <C-O>:TmuxNavigateDown<cr>

  " (Becaues I like Alt-Left/-Right to move cursor to -beg/-end of line, use)
  " Alt-PageUp/-PageDown (*not* -Left/-Right) to switch to pane -left/-right.
  " 2020-05-23: (lb): I tried swapping keybindings, trading M-PageUp/-PageDown
  " dubs_edit_juice's ^/$ motions, M-Left/-Right, but I didn't last more than
  " fifteen seconds. On common motion I do is Alt-Left followed by one or more
  " Shift-Down's, to select lines of text from insert mode. Making the switch,
  " too, I realized how often I also Alt-Right, especially after typing something
  " new, seeing a typo, going back to fix the typo, then Alt-Right to pick up
  " where I left off. So many little use cases. I'm a lost cause. I can't have
  " a pure Alt-Arrow experience for Switching Panes/Windows. Which means I might
  " stumble trying to switch panes left and right, because Alt-PageUp and
  " Alt-PageDown don't feel the most natural, but it's way better than my
  " alternative experience.
  " FIXME/2020-05-23: In any case, the keybindings themselves should be specified
  "                   using g:global variables, so that users can easily change.

  nnoremap <silent> <M-PageUp> :TmuxNavigateLeft<cr>
  inoremap <silent> <M-PageUp> <C-O>:TmuxNavigateLeft<cr>

  nnoremap <silent> <M-PageDown> :TmuxNavigateRight<cr>
  inoremap <silent> <M-PageDown> <C-O>:TmuxNavigateRight<cr>

  " ++++++++++++++++++++++

  " Wire Ctrl-Command plus Arrow keys to jumping
  " between panes (whether Vim or Tmux).
  "
  " (Where 'Command' refers to macOS 'Command' key,
  "  Windows 'Start' key, or Linux 'Super_L' or 'Mod4'
  "  key, what is all essentially the same logical key,
  "  i.e., the meta key that's not the Ctrl, Alt, or
  "  Option key, that is unless you're on some crazy
  "  nerdy keyboard.)
  "
  " - Note that these Ctrl-Command-Arrow combos do the same operation
  "   as the Alt-Up/-Down and Alt-PageUp/-PageDown shortcuts. It's just
  "   the I've always wanted something a little more consistent (that
  "   uses all arrow keys rather than PageUp and PageDown), but I got
  "   stuck not wanting to lost the existing Alt-Left/-Right mappings
  "   (that I've been accustomed to since early 00's EditPlus days).

  " 2021-01-30: I'm surprised it only took me 10 years to add
  " Super_L/Command key mappings to Vim... it definately adds
  " more breathing room to what was a crowed arena of combos
  " using the few available meta keys and arrow keys!
  "
  " - If you read on Stack Overflow, most answers strongly
  "   suggest *not* overriding the OS key, because of how
  "   integrated it is with existing, conventional commands.
  "
  "   But if you've done your legwork, you'll be fine.
  "
  "   - On macOS, you can use the builtin Keyboard Settings
  "     as well as Karabiner-Elements to remap everything
  "     how you like -- I went so far as to remap all the
  "     common Command combos to Control (like Ctrl-C/-V/-X
  "     and even Ctrl-S/-W/-Q), and then I swapped Option and
  "     Command, so my macOS keyboard experience is almost
  "     identical to my Linux experience!
  "
  "   - On Linux, not many applications use the Super_L aka
  "     <Mod4> key. Many applications use Alt key shortcuts,
  "     e.g., Alt-f to show file menu, and then pressing
  "     another key to choose a menu option.
  "
  "     MATE itself (and other window managers) map some
  "     Command key shortcuts, but these are easily changed
  "     via the typical Keyboard Settings dialog.
  "
  "   - So go wild! Make use of all the keys your keyboard
  "     gives you.
  "
  "   - I like to use the various shift, meta and arrow key
  "     combinations to perform cursor and window motions.
  "     It helps me bounce around text files and application
  "     windows quickly and painlessly.

  " HINT: I figured out the <T-C-Left> and other <shortcuts> to use
  "       using Ctrl-q (the Ctrl-v alternative; see :help i_CTRL-V).
  "
  "       Press <C-q> and then type the meta+key command you want to
  "       use, and if it contains special characters, they'll be
  "       generated. Use the <C-q> output for the map <shortcut>.

  nnoremap <silent> <T-C-Left> :TmuxNavigateLeft<cr>
  inoremap <silent> <T-C-Left> <C-O>:TmuxNavigateLeft<cr>

  nnoremap <silent> <T-C-Up> :TmuxNavigateUp<cr>
  inoremap <silent> <T-C-Up> <C-O>:TmuxNavigateUp<cr>

  nnoremap <silent> <T-C-Down> :TmuxNavigateDown<cr>
  inoremap <silent> <T-C-Down> <C-O>:TmuxNavigateDown<cr>

  nnoremap <silent> <T-C-Right> :TmuxNavigateRight<cr>
  inoremap <silent> <T-C-Right> <C-O>:TmuxNavigateRight<cr>

  " +++

  nnoremap <silent> <D-C-Left> :TmuxNavigateLeft<cr>
  inoremap <silent> <D-C-Left> <C-O>:TmuxNavigateLeft<cr>

  nnoremap <silent> <D-C-Up> :TmuxNavigateUp<cr>
  inoremap <silent> <D-C-Up> <C-O>:TmuxNavigateUp<cr>

  nnoremap <silent> <D-C-Down> :TmuxNavigateDown<cr>
  inoremap <silent> <D-C-Down> <C-O>:TmuxNavigateDown<cr>

  nnoremap <silent> <D-C-Right> :TmuxNavigateRight<cr>
  inoremap <silent> <D-C-Right> <C-O>:TmuxNavigateRight<cr>

  " ++++++++++++++++++++++

  " Use Alt-\ to toggle focus between current pane and previously-focused pane.
  " (Many other developers might have this wired to Ctrl-\.)

  nnoremap <silent> <M-\> :TmuxNavigateLast<cr>
  inoremap <silent> <M-\> <C-O>:TmuxNavigateLast<cr>

  " Ctrl-Shift-Up/-Down cycle focus counter-clockwise/closewise around panes.

  nnoremap <silent> <C-S-Up> :TmuxNavigatePrevious<cr>
  inoremap <silent> <C-S-Up> <C-O>:TmuxNavigatePrevious<cr>

  nnoremap <silent> <C-S-Down> :TmuxNavigateNext<cr>
  inoremap <silent> <C-S-Down> <C-O>:TmuxNavigateNext<cr>

endfunction

call <SID>wire_keys_jump_to_window_directionally()

" -------

function! s:wire_keys_jump_to_window_progressively()

  " This is Alt-PageDown to Next Tab Page
  " NOTE gt is the Normal mode shortcut
  " 2012.06.26: [lb] Does anyone use Tabs ever?
  noremap <M-S-Down> :tabn<CR>
  inoremap <M-S-Down> <C-O>:tabn<CR>
  cnoremap <M-S-Down> <C-C>:tabn<CR>
  onoremap <M-S-Down> <C-C>:tabn<CR>

  " This is Alt-PageUp to Previous Tab Page
  " NOTE gT is the Normal mode shortcut
  noremap <M-S-Up> :tabN<CR>
  inoremap <M-S-Up> <C-O>:tabN<CR>
  cnoremap <M-S-Up> <C-C>:tabN<CR>
  onoremap <M-S-Up> <C-C>:tabN<CR>

endfunction

call <SID>wire_keys_jump_to_window_progressively()

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Mini Buffer Explorer Shortcut
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" 2017-11-02: Removed minibufexpl.vim.
function! s:FindAndSourceMiniBufExpl_DEPRECATED()
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
  " 2017-11-02: Removed minibufexpl.vim.
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
    " 2017-11-02: Removed minibufexpl.vim.
    "call confirm('Dubs: Cannot find MiniBuf Explorer', 'OK')
  endif
  " 2015.01.15: Deprecated: CMiniBufExplorer, replaced by MBEClose.
  autocmd VimEnter * nested
    \ let greatest_buf_no = bufnr('$') |
    \ if (greatest_buf_no == 1)
    \     && (bufname(1) == "") |
    \   execute "MBEClose" |
    \ endif
endfunction

" New 2011.01.13: Smart toggle. If you don't do this and your Quickfix window
" is open, toggling the minibuf window will make the Quickfix window taller.
"   The old way:
""     nmap <M-@> <Plug>TMiniBufExplorer
""     imap <M-@> <C-O><Plug>TMiniBufExplorer
"     nmap <M-@> <Plug>MBEToggle
"     imap <M-@> <C-O><Plug>MBEToggle
"     "cmap <M-&> <C-C><Plug>DubsHtmlEntities_ToggleLookup<ESC>
"     "omap <M-&> <C-C><Plug>DubsHtmlEntities_ToggleLookup<ESC>

" SYNC_ME: Dubs Vim's <M-????> mappings are spread across plugins. [M-S-2]
"nmap <M-@> :call ToggleMiniBufExplorer()<CR>
"imap <M-@> <C-O>:call ToggleMiniBufExplorer()<CR>
" 2017-11-02: Removed minibufexpl.vim. Because it breaks Vim if you use netrw (:Explore).
"nmap <M-@> :ToggleMiniBufExplorer<CR>
"imap <M-@> <C-O>:ToggleMiniBufExplorer<CR>
" FIXME/2017-11-02: Find a better way to do this.
"   1. If netrw open, pressing Alt-Shift-F2 should close the browser.
nmap <M-@> :Lexplore<CR>
imap <M-@> <C-O>:Lexplore<CR>

" FIXME Toggling minibufexplorer in insert mode marks current buffer dirty
"       2011.01.18 I noticed this yesterday but today I'm not seeing it...

" ------------------------------------------------------
" A few commands I don't use...
" ------------------------------------------------------

" ============== DEPRECATED

" 2021-01-24: Note that `wincmd _` only maximizes height. It will
" reduce any panes above to 1 line each, plus their status lines.

" Remap ,m to make and open error window if there are any errors. If there
" weren't any errors, the current window is maximized.
"map <silent> ,m :mak<CR><CR>:cw<CR>:call MaximizeIfNotQuickfix()<CR>

" Maximizes the current window if it is not the quickfix window.
function! MaximizeIfNotQuickfix()
  if (getbufvar(winbufnr(winnr()), "&buftype") != "quickfix")
    wincmd _
  endif
endfunction

" ============== DEPRECATED

" http://vim.wikia.com/wiki/Always_keep_quickfix_window_at_specified_height

" Maximize the window after entering it, be sure to keep the quickfix window
" at the specified height.
"au WinEnter * call MaximizeAndResizeQuickfix(12)

" Maximize current window and set the quickfix window to the specified height.
function! MaximizeAndResizeQuickfix(quickfixHeight)
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

" ------------------------------------------------------
" Vertical-split shortcut
" ------------------------------------------------------

function s:DubsBufferFun_VerticalSplit_vv()
  " https://www.bugsnag.com/blog/tmux-and-vim
  " vv to generate new vertical split
  nnoremap <silent> vv <C-w>v
endfunction

" ***

function! s:DubsBufferFun_Main()
  call <SID>DubsBufferFun_VerticalSplit_vv()
endfunction

call <SID>DubsBufferFun_Main()

