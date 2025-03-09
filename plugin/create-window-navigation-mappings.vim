" vim:tw=0:ts=2:sw=2:et:norl:
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/embrace-vim/vim-buffer-delights#🍧
" License: vim-buffer-delights by Landon Bouma is marked with CC0 1.0
"   https://creativecommons.org/publicdomain/zero/1.0/
"   Copyright © 2009, 2015, 2017, 2024 Landon Bouma.

" -------------------------------------------------------------------

" GUARD: Press <F9> to reload this plugin (or :source it).
" - Via: https://github.com/embrace-vim/vim-source-reloader#↩️

if expand('%:p') ==# expand('<sfile>:p')
  unlet! g:loaded_vim_buffer_delights_navigation_mappings
endif

if exists('g:loaded_vim_buffer_delights_navigation_mappings') || &cp

  finish
endif

let g:loaded_vim_buffer_delights_navigation_mappings = 1

" -------------------------------------------------------------------

if get(g:, 'vim_buffer_delights_disable', 0)

  finish
endif

" -------------------------------------------------------------------

" --------------------------------
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
"     " And this is Ctrl-Shift-Up to Previous Window
"     nnoremap <C-S-Up> :call <SID>JumpWindow('W', 0)<CR>
"     inoremap <C-S-Up> <C-O>:call <SID>JumpWindow('W', 1)<CR>
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
  "  i.e., the modifier key that's not the Ctrl, Alt, or
  "  Option key, that is unless you're on some strange
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
  " using the few available modifier keys and arrow keys!
  "
  " - If you read on Stack Overflow, most answers strongly
  "   suggest *not* overriding the OS key, because of how
  "   integrated it is with existing, conventional commands.
  "
  "   But if you've done your legwork, you'll be fine.
  "
  "   - On macOS, you can use the builtin Keyboard Settings
  "     as well as Hammerspoon (or Karabiner-Elements, or
  "     skhdrc) to remap everything how you like — I went so
  "     far as to remap all the common Command combos to
  "     Control (like Ctrl-C/-V/-X and even Ctrl-S/-W/-Q),
  "     and then I swapped Option and Command, so my macOS
  "     keyboard experience is almost identical to my Linux
  "     experience!
  "
  "   - On MATE, not many applications use the Super_L aka
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
  "   - I like to use the various modifier and arrow key
  "     combinations to perform cursor and window motions.
  "     It helps me bounce around text files and application
  "     windows quickly and easily.

  " HINT: You can print the combo seq using i_CTRL-V, which
  " maybe you've mapped from Ctrl-q if you use Ctrl-v to
  " paste. E.g., if you press <Ctrl-q> then <Alt-a>, Neo(vim)
  " inserts "<M-a>". (See :help i_CTRL-V).

  nnoremap <silent> <T-C-Left> :TmuxNavigateLeft<cr>
  inoremap <silent> <T-C-Left> <C-O>:TmuxNavigateLeft<cr>

  nnoremap <silent> <T-C-Up> :TmuxNavigateUp<cr>
  inoremap <silent> <T-C-Up> <C-O>:TmuxNavigateUp<cr>

  nnoremap <silent> <T-C-Down> :TmuxNavigateDown<cr>
  inoremap <silent> <T-C-Down> <C-O>:TmuxNavigateDown<cr>

  nnoremap <silent> <T-C-Right> :TmuxNavigateRight<cr>
  inoremap <silent> <T-C-Right> <C-O>:TmuxNavigateRight<cr>

  " <Ctrl-Command-Left|Up|Down|Right> (author likes these the best):

  nnoremap <silent> <D-C-Left> :TmuxNavigateLeft<cr>
  inoremap <silent> <D-C-Left> <C-O>:TmuxNavigateLeft<cr>

  nnoremap <silent> <D-C-Up> :TmuxNavigateUp<cr>
  inoremap <silent> <D-C-Up> <C-O>:TmuxNavigateUp<cr>

  nnoremap <silent> <D-C-Down> :TmuxNavigateDown<cr>
  inoremap <silent> <D-C-Down> <C-O>:TmuxNavigateDown<cr>

  nnoremap <silent> <D-C-Right> :TmuxNavigateRight<cr>
  inoremap <silent> <D-C-Right> <C-O>:TmuxNavigateRight<cr>

  " +++

  nnoremap <silent> <T-M-Left> :TmuxNavigateLeft<cr>
  inoremap <silent> <T-M-Left> <C-O>:TmuxNavigateLeft<cr>

  nnoremap <silent> <T-M-Up> :TmuxNavigateUp<cr>
  inoremap <silent> <T-M-Up> <C-O>:TmuxNavigateUp<cr>

  nnoremap <silent> <T-M-Down> :TmuxNavigateDown<cr>
  inoremap <silent> <T-M-Down> <C-O>:TmuxNavigateDown<cr>

  nnoremap <silent> <T-M-Right> :TmuxNavigateRight<cr>
  inoremap <silent> <T-M-Right> <C-O>:TmuxNavigateRight<cr>

  " +++

  " <Command-Alt-Left|Up|Down|Right> (and works regardless of meta-key
  " enablement, i.e., if macOS Option key emits literal chars. or not).

  nnoremap <silent> <D-M-Left> :TmuxNavigateLeft<cr>
  inoremap <silent> <D-M-Left> <C-O>:TmuxNavigateLeft<cr>

  nnoremap <silent> <D-M-Up> :TmuxNavigateUp<cr>
  inoremap <silent> <D-M-Up> <C-O>:TmuxNavigateUp<cr>

  nnoremap <silent> <D-M-Down> :TmuxNavigateDown<cr>
  inoremap <silent> <D-M-Down> <C-O>:TmuxNavigateDown<cr>

  nnoremap <silent> <D-M-Right> :TmuxNavigateRight<cr>
  inoremap <silent> <D-M-Right> <C-O>:TmuxNavigateRight<cr>

  " +++

  " 2021-02-01: Hang on a tick, what about the Numpad?
  "
  " - The keypad identifiers have a k* prefix.
  "   - Ref: :h keycodes
  "   - However, this only works for me without a modifier or with
  "     Ctrl, e.g., <k4> or <C-k4>, but not with Alt, e.g., <M-k4>.
  "   - But it works fine with the normal number keys, e.g., <M-4>.
  "
  " LATER/2021-02-01: Consolidate all the TmuxNavigate* commands
  "                   (once you decide which ones work the best).

  nnoremap <silent> <M-4> :TmuxNavigateLeft<cr>
  inoremap <silent> <M-4> <C-O>:TmuxNavigateLeft<cr>

  nnoremap <silent> <M-8> :TmuxNavigateUp<cr>
  inoremap <silent> <M-8> <C-O>:TmuxNavigateUp<cr>

  nnoremap <silent> <M-2> :TmuxNavigateDown<cr>
  inoremap <silent> <M-2> <C-O>:TmuxNavigateDown<cr>

  nnoremap <silent> <M-6> :TmuxNavigateRight<cr>
  inoremap <silent> <M-6> <C-O>:TmuxNavigateRight<cr>

  " ++++++++++++++++++++++

  " Use Alt-\ to toggle focus between current pane and previously-focused pane.
  " (Many other developers might have this wired to Ctrl-\.)

  nnoremap <silent> <M-\> :TmuxNavigateLast<cr>
  inoremap <silent> <M-\> <C-O>:TmuxNavigateLast<cr>

  " Ctrl-Shift-Up/-Down cycle focus counter-clockwise/closewise around panes.

  nnoremap <silent> <C-S-Up> :if exists('*TmuxNavigatePrevious') \|
   \ exec 'TmuxNavigatePrevious' \| else \| wincmd W \| endif<CR>
  inoremap <silent> <C-S-Up> <C-O>:if exists('*TmuxNavigatePrevious') \|
    \ exec 'TmuxNavigatePrevious' \| else \| wincmd W \| endif<CR>

  nnoremap <silent> <C-S-Down> :if exists('*TmuxNavigateNext') \|
    \ exec 'TmuxNavigateNext' \| else \| wincmd w \| endif<CR>
  inoremap <silent> <C-S-Down> <C-O>:if exists('*TmuxNavigateNext') \|
    \ exec 'TmuxNavigateNext' \| else \| wincmd w \| endif<CR>

endfunction

" -------------------------------------------------------------------

function! s:wire_keys_jump_to_window_progressively()

  " This is Alt-PageDown to Next Tab Page
  " - ALTLY: You can also gT in Normal mode.
  nnoremap <M-S-Down> :tabn<CR>
  inoremap <M-S-Down> <C-O>:tabn<CR>

  " This is Alt-PageUp to Previous Tab Page
  " - ALTLY: You can also gT in Normal mode.
  nnoremap <M-S-Up> :tabN<CR>
  inoremap <M-S-Up> <C-O>:tabN<CR>

endfunction

" -------------------------------------------------------------------

call <SID>wire_keys_jump_to_window_directionally()

call <SID>wire_keys_jump_to_window_progressively()

