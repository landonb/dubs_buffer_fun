" vim:tw=0:ts=2:sw=2:et:norl:
" Author: Landon Bouma <https://tallybark.com/> 
" Project: https://github.com/embrace-vim/vim-buffer-delights#🍧
" License: vim-buffer-delights by Landon Bouma is marked with CC0 1.0
"   Copyright © 2020, 2024 Landon Bouma.
"   https://creativecommons.org/publicdomain/zero/1.0/

" -------------------------------------------------------------------

" Identify *normal* buffer — i.g., not quickfix window, help window, etc.
"
" - Because you probably don't want to open a file for editing in a
"   special buffer window. (It's just bad UX, for one.)
"
" - REFER: See similar logic in another plugin:
"     s:BufSurfTargetable()
"     s:BufSurfDisabled()
"   https://github.com/landonb/vim-buffer-ring#💍
"
"   That plugin uses similar logic (check bufexists, buflisted, and &ft)
"   for effectively the same outcome.
"
"   - (And though both plugins are maintained by this same author, there's
"      no good reason to DRY the code — mostly because of the implementation
"      details in the other, which splits the logic throughout a few
"      different fcns. and is not isolated in a single fcn. like it is here.
"      (I.e., more work than it's worth.))
"
" - SAVVY: Some different methods for testing the *bufferness*:
"
"   - &filetype
"
"     - Vim filetypes: Quickfix ('qf'), and Help ('help').
"
"     - tpope/vim-fugitive: 'git' and 'fugitiveblame'.
"
"   - &buftype
"
"     - Empty for editable files (a *normal buffer*), or set to an
"       obvious value, such as 'quickfix' or 'help', otherwise 'nofile',
"       'nowrite', 'acwrite', 'terminal', 'prompt', or 'popup'.
"
"     - Per non obvious values:
"
"       - nofile:   'buffer which is not related to a file and will
"                    not be written'
"
"       - nowrite:  'buffer which will not be written'
"
"       - acwrite:  'buffer which will always be written with
"                    BufWriteCmd autocommands'
"
"       - terminal: 'buffer for a |terminal|'
"
"       - prompt:   'buffer where only the last line can be edited'
"
"       - popup:    'buffer used in a popup window'
"
"       - quickfix: Unlisted in the help for `buftype`, but set for
"                   the QuickFix window.
"
"     - And while author is not familar with all these buffer types,
"       it seems like we only care about buffers without a buftype.
"
"   - &previewwindow
"
"     - Identifies the preview window. See :ptag, :pedit, etc.
"
"   - &modifiable
"
"     - 'When off the buffer contents cannot be changed.'
"
"   - buflisted
"
"     - 'help' is not listed, nor project tray buffer (eventually).
"
"     - Though note the project tray buffer is initially buflisted,
"       until the first BufEnter callback (see its s:DoSetup()).
"
"         https://github.com/landonb/dubs_project_tray#🗂
"
"   - bufexists
"
"     - One might use this to check that a buffer still exists and
"       was not bwipe'd, e.g., bufexists(a:bufnr). But we don't
"       cache buffer numbers, and !bugexists won't be the case for
"       any buffer loaded into an existing window.

function! g:embrace#windows#IsNormalBuffer(bufnr) abort
  " Note that using special buffers (see :bufname for list)
  " such as '%' (name of current buffer) doesn't work for
  " &modifiable, which reports false (0) for modifiables.
  " - DUNNO: I'm didn't investigate. It's just what I see.
  let l:bufnr = bufnr(a:bufnr)

  let l:ftype = getbufvar(l:bufnr, "&filetype")

  if 0
    \ || getbufvar(l:bufnr, '&buftype') != ''
    \ || getbufvar(l:bufnr, "&previewwindow")
    \ || !getbufvar(l:bufnr, "&modifiable")
    \ || !buflisted(l:bufnr)
    \ || l:ftype == 'qf'
    \ || l:ftype == 'help'
    \ || l:ftype == 'git'
    \ || l:ftype == 'fugitiveblame'
    \ || bufname(l:bufnr) == '-MiniBufExplorer-'

    return 0
  endif

  return 1
endfunction

" -------------------------------------------------------------------

function! g:embrace#windows#FindNextWindowWithNormalBuffer(start_winnr = 0) abort
  let l:found_winnr = 0

  let l:final_winnr = winnr('$')

  if a:start_winnr == 0
    let l:start_winnr = winnr()
  elseif a:start_winnr > l:final_winnr
    let l:start_winnr = 1
  else
    let l:start_winnr = a:start_winnr
  endif

  let l:visit_winnr = l:start_winnr

  while l:visit_winnr <= l:final_winnr
    let l:bufnr = winbufnr(l:visit_winnr)

    if g:embrace#windows#IsNormalBuffer(l:bufnr)
      " All good!
      let l:found_winnr = l:visit_winnr

      break
    endif

    " Didn't break, so window contains the project tray, help, quickfix, or
    " preview, etc. Skip current window and while again to test next window.
    let l:visit_winnr += 1

    " Check if we've passed the last window and should reset to first window.
    if l:visit_winnr > l:final_winnr
      let l:visit_winnr = 1
    endif

    " Check if we've wrapped around back to the start.
    if l:visit_winnr == l:start_winnr
      break
    endif
  endwhile

  return l:found_winnr
endfunction

" -------------------------------------------------------------------

function! g:embrace#windows#FocusCursorInNormalBufferWindow() abort
  let l:found_winnr = g:embrace#windows#FindNextWindowWithNormalBuffer(winnr())

  " Check if there was only one window found and if it's special.
  if l:found_winnr == 0
    if &ft == 'qf'
      " Open new window, split horizontally.
      wincmd s
      " Note that this leaves the two windows 50-50, and I normally have
      " my quickfix at about 20% of the height. Or 80% of total height.
      execute "resize " . float2nr(winheight(0) * 2 * 0.8)
    else
      " Open new window, split vertically.
      wincmd v
    endif
  else
    " Otherwise, success! Move cursor to the identified window.
    execute l:found_winnr . 'wincmd w'
  endif
endfunction

" -------------------------------------------------------------------

function! g:embrace#windows#CloseVimHelpWindow() abort
  let l:curr_winnr = 1
  let l:last_winnr = winnr('$')

  while l:curr_winnr <= l:last_winnr
    let l:bufnr = winbufnr(l:curr_winnr)
    let l:ftype = getbufvar(l:bufnr, "&filetype")

    if l:ftype == 'help'
      execute l:curr_winnr . "wincmd q"

      break
    endif

    let l:curr_winnr += 1
  endwhile
endfunction

" -------------------------------------------------------------------

function! g:embrace#windows#open_file_adjacent(fpath = '') abort
  if a:fpath != ''
    let l:fpath = expand(a:fpath)
  else
    " We run expand() twice, because first one returns string,
    " which might contain tilde (~).
    let l:fpath = expand(expand("<cfile>"))
  endif

  if !filereadable(l:fpath)
    try
      " If user has vim-goto-file-sh installed, try to expand
      " shell-syntax environment variables.
      "   https://github.com/embrace-vim/vim-goto-file-sh#🚕
      " If fcn. absent, throws /^Vim\%((\a\+)\)\=:E117:/
      " - E.g., E117: Unknown function: foo#bar#baz
      let l:fpath = g:embrace#sh_expand#ExpandShellParameters(l:fpath)
    endtry
  endif

  if !filereadable(l:fpath)
    echom "Unreadable or absent file: " .. l:fpath

    return
  endif

  let l:curr_winnr = winnr()

  let l:found_winnr = g:embrace#windows#FindNextWindowWithNormalBuffer(winnr() + 1)

  " If window is before current window, see if adjacent window on left/top
  " is normal.
  let l:adjacent_winnr = l:curr_winnr - 1

  if l:found_winnr < l:curr_winnr
      \ && g:embrace#windows#IsNormalBuffer(winbufnr(l:adjacent_winnr))
    let l:found_winnr = l:adjacent_winnr
  endif

  if l:found_winnr == l:curr_winnr || l:found_winnr == 0
    " Current buffer is only normal buffer, or none are, so open new split.
    " MAYBE/2024-12-16: Let user choose horizontal :split instead
    exe "vsplit " .. fpath
    " Swap windows, because the new file was opened in the left window.
    " Then move cursor one window to the right/below.
    "   :h CTRL-W_x
    "   :h CTRL-W_w
    exe "normal! \<C-w>x\<C-w>w"
  else
    exe l:found_winnr .. "wincmd w"
    exe "e " .. fpath
  endif
endfunction

" -------------------------------------------------------------------

