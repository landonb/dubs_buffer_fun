################################################
Delightful Buffer and Window Features for Vim 🍧
################################################

About This Plugin
=================

Buffer and window navigation features for Vim.

This plugin defines a few automatic commands:

- Automatically jump to last known cursor position when
  opening a file.

- Enable ``hidden`` so buffers are not unloaded when abandoned.

Disable The Plugin
==================

If you'd just like to use the ``autoload/`` functions, or nothing
at all, set the following global to disable all command maps
and ``plugin/`` setup:

.. code-block::

  let g:vim_buffer_delights_disable = 1

Buffer-Related Commands
=======================

Switching MRU buffers
---------------------

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<F2>``                     Toggle MRU Buffer             Jump to the most recently used buffer:
                                                            Loads the last loaded buffer in the current window (think ``:e #``).
                                                            I.e., if you hit ``<F2>`` twice, you'll be looking at the same buffer.
===========================  ============================  ==============================================================================

Find buffers by name
--------------------

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Shift-F2>``               Show buffer list and          Calls ``:ls<CR>:b<Space>`` so you can see the list of buffers and
                              prompt for number             then either type a buffer name or type (part of) a filename
                              or (partial) name             followed by <enter> to switch buffers.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``__``                       Show buffer list prompt       Similar to ``<Shift-F2>``, but simpler.
===========================  ============================  ==============================================================================

Related Vim commands
--------------------

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``:b filena<CR>``            Switch to Buffer
                              by (partial) Name
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``:ls``                      List buffer numbers           Hint: ``map <S-F2> :ls<CR>:b<Space>`` is a nifty *switcheroo*.
                              and names
===========================  ============================  ==============================================================================

Window-Related Commands
=======================

Window-related commands
-----------------------

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Ctrl-Shift-Up>``          Move Cursor to Window         Moves the cursor to the window above the current window,
                              Above or Leftward             or the window to the left.
                                                            - Note: ``mswin.vim`` wires ``<Shift-Ctrl-Tab>`` to same.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Ctrl-Shift-Down>``        Move Cursor to Window         Moves the cursor to the window to the right of
                              to Right or Below             or below the current window.
                                                            - Note: ``mswin.vim`` wires ``<Ctrl-Tab>`` to same.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``vv``                       New Vertical Split            Creates a new vertical-split window, with the
                                                            same buffer visible in each window.
===========================  ============================  ==============================================================================

Dubs Vim ``netrw`` Commands
---------------------------

These are window commands custom to Dubs Vim.

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Shift-Alt-2>``            Toggle ``:netrw``             Toggles the ``netrw`` ``:Lexplore`` window.
===========================  ============================  ==============================================================================

tmux-Compatible Navigation Commands
===================================

``<Ctrl-Up/Down/PageUp/PageDown>`` window jumpers
-------------------------------------------------

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Alt-Up>``                 Move Cursor to Window         Switch to Vim or tmux window above.
                              Above
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Alt-Down>``               Move Cursor to Window         Switch to Vim or tmux window below.
                              Below
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Alt-PageUp>``             Move Cursor to Window         Switch to Vim or tmux window leftward.
                              Leftward
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Alt-PageDown>``           Move Cursor to Window         Switch to Vim or tmux window rightward.
                              Rightward
===========================  ============================  ==============================================================================

``<Cmd-Ctrl-Up/Down/Left/Right>`` window jumpers
------------------------------------------------

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Cmd-Ctrl-Up>``            Move Cursor to Window         Switch to Vim or tmux window above.
                              Above
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Cmd-Ctrl-Down>``          Move Cursor to Window         Switch to Vim or tmux window below.
                              Below
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Cmd-Ctrl-Left>``          Move Cursor to Window         Switch to Vim or tmux window leftward.
                              Leftward
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Cmd-Ctrl-Right>``         Move Cursor to Window         Switch to Vim or tmux window rightward.
                              Rightward
===========================  ============================  ==============================================================================

``<Cmd-Alt-Up/Down/Left/Right>`` window jumpers
-----------------------------------------------

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Cmd-Alt-Up>``             Move Cursor to Window         Switch to Vim or tmux window above.
                              Above
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Cmd-Alt-Down>``           Move Cursor to Window         Switch to Vim or tmux window below.
                              Below
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Cmd-Alt-Left>``           Move Cursor to Window         Switch to Vim or tmux window leftward.
                              Leftward
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Cmd-Alt-Right>``          Move Cursor to Window         Switch to Vim or tmux window rightward.
                              Rightward
===========================  ============================  ==============================================================================

``<Alt-Numpad>`` window jumpers
-----------------------------------------------

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Alt-8>``                  Move Cursor to Window         Switch to Vim or tmux window above.
                              Above
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Alt-2>``                  Move Cursor to Window         Switch to Vim or tmux window below.
                              Below
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Alt-4>``                  Move Cursor to Window         Switch to Vim or tmux window leftward.
                              Leftward
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Alt-6>``                  Move Cursor to Window         Switch to Vim or tmux window rightward.
                              Rightward
===========================  ============================  ==============================================================================

MRU window jumper
-----------------

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Alt-\>``                  Move Cursor to MRU Window     Toggle focus between current and previously-focused window.
===========================  ============================  ==============================================================================

Cyclical window jumpers
-----------------------

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Ctrl-Shift-Up>``          Move Cursor Counter-          Cycle focus counter-clockwise around windows.
                              Clockwise
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Ctrl-Shift-Down>``        Move Cursor Clockwise         Cycle focus clockwise around windows.
===========================  ============================  ==============================================================================

Tab-Related Navigation Commands
===============================

Tab jumpers
-----------

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Alt-Shift-Up>``           Previous Tab                  Switch to previous tab page.
                                                            - Same as ``gt`` in normal mode.
                                                            - Same as ``<Ctrl-Alt-PageDown>``.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Alt-Shift-Down>``         Next Tab                      Switch to next tab page.
                                                            - Same as ``gT`` in normal mode.
                                                            - Same as ``<Ctrl-Alt-PageUp>``.
===========================  ============================  ==============================================================================

Installation
============

Installation is easy using the packages feature (see ``:help packages``).

To install the package so that it will automatically load on Vim startup,
use a ``start`` directory, e.g.,

.. code-block::

    mkdir -p ~/.vim/pack/embrace-vim/start
    cd ~/.vim/pack/embrace-vim/start

If you want to test the package first, make it optional instead
(see ``:help pack-add``):

.. code-block::

    mkdir -p ~/.vim/pack/embrace-vim/opt
    cd ~/.vim/pack/embrace-vim/opt

Clone the project to the desired path:

.. code-block::

    git clone https://github.com/embrace-vim/vim-buffer-delights.git

If you installed to the optional path, tell Vim to load the package:

.. code-block:: vim

    :packadd! vim-buffer-delights

Just once, tell Vim to build the online help:

.. code-block:: vim

    :Helptags

Then whenever you want to reference the help from Vim, run:

.. code-block:: vim

    :help vim-buffer-delights

.. |vim-plug| replace:: ``vim-plug``
.. _vim-plug: https://github.com/junegunn/vim-plug

.. |Vundle| replace:: ``Vundle``
.. _Vundle: https://github.com/VundleVim/Vundle.vim

.. |myrepos| replace:: ``myrepos``
.. _myrepos: https://myrepos.branchable.com/

.. |ohmyrepos| replace:: ``ohmyrepos``
.. _ohmyrepos: https://github.com/landonb/ohmyrepos

Note that you'll need to update the repo manually (e.g., ``git pull``
occasionally).

- If you'd like to be able to update from within Vim, you could use
  |vim-plug|_.

  - You could then skip the steps above and register
    the plugin like this, e.g.:

.. code-block:: vim

    call plug#begin()

    " List your plugins here
    Plug 'embrace-vim/vim-buffer-delights'

    call plug#end()

- And to update, call:

.. code-block:: vim

    :PlugUpdate

- Similarly, there's also |Vundle|_.

  - You'd configure it something like this:

.. code-block:: vim

    set nocompatible              " be iMproved, required
    filetype off                  " required

    " set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    " alternatively, pass a path where Vundle should install plugins
    "call vundle#begin('~/some/path/here')

    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'

    Plugin 'embrace-vim/vim-buffer-delights'

    " All of your Plugins must be added before the following line
    call vundle#end()            " required
    filetype plugin indent on    " required
    " To ignore plugin indent changes, instead use:
    "filetype plugin on

- And then to update, call one of these:

.. code-block:: vim

    :PluginInstall!
    :PluginUpdate

- Or, if you're like the author, you could use a multi-repo Git tool,
  such as |myrepos|_ (along with the author's library, |ohmyrepos|_).

  - With |myrepos|_, you could update all your Git repos with
    the following command:

.. code-block::

    mr -d / pull

- Alternatively, if you use |ohmyrepos|_, you could pull
  just Vim plugin changes with something like this:

.. code-block::

    MR_INCLUDE=vim-plugins mr -d / pull

- After you identify your vim-plugins using the 'skip' action, e.g.:

.. code-block::

    # Put this in ~/.mrconfig, or something loaded by it.
    [DEFAULT]
    skip = mr_exclusive "vim-plugins"

    [pack/embrace-vim/start/vim-buffer-delights]
    lib = remote_set origin https://github.com/embrace-vim/vim-buffer-delights.git

    [DEFAULT]
    skip = false

Attribution
===========

.. |embrace-vim| replace:: ``embrace-vim``
.. _embrace-vim: https://github.com/embrace-vim

.. |@landonb| replace:: ``@landonb``
.. _@landonb: https://github.com/landonb

The |embrace-vim|_ logo by |@landonb|_ contains
`coffee cup with straw by farra nugraha from Noun Project
<https://thenounproject.com/icon/coffee-cup-with-straw-6961731/>`__
(CC BY 3.0).

