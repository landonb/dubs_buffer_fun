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

Disablement
===========

If you'd just like to use the ``autoload/`` functions, or nothing
at all, set the following global to disable all command maps
and ``plugin/`` setup:

.. code-block::

  let g:vim_buffer_delights_disable = 1

Buffer and Window Commands
==========================

Note: Some useful, similar Vim commands are listed alongside
the Dubs Vim functions, just to remind us of all the commands
available.

Changing Buffers
----------------

It's easy to switch between buffers, especially the
most-recently-used buffer, or the next or last buffer
in the history stack.

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<F2>``                     Toggle MRU Buffer             Jump to the most recently used buffer:
                                                            Loads the last loaded buffer in the current window (think ``:e #``).
                                                            I.e., if you hit ``<F2>`` twice, you'll be looking at the same buffer.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Ctrl-J>``                 Traverse Buffer History       Traverses the buffer history backwards.
                                                            Hint: If you find yourself down a rabbit hole, opening file after file,
                                                            and you can't remember what you were doing, hit ``<Ctrl-J>`` to crawl out of it.
                                                            Caveat: Splitting and Closing windows can mess up the buffer history, 'natch.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Ctrl-K>``                 Forward Traverse History      Traverses the buffer history forwards; opposite of ``<Ctrl-J>``.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Ctrl-Tab>``               Traverse BufList              ``<Ctrl-Tab>`` and ``<Ctrl-Shift-Tab>``
                                                            are similar to ``<Ctrl-J>`` and ``<Ctrl-K>``
                                                            but traverse the list of buffers in the order
                                                            that they were originally loaded.
                                                            Note: In default Vim, these commands
                                                            move the cursor between windows,
                                                            i.e., like ``<Alt-Shift-Up>`` and ``<Alt-Shift-Down>`` now do.
                                                            ([lb] admits that Ctrl-Tab switches tabs in a lot of apps
                                                            (vis-à-vis web browsers) but I've never found tabs to be
                                                            useful in Vim, other than to run the ``:TabMessage`` command;
                                                            I switch windows and buffers, not tabs.)
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Ctrl-Shift-Tab>``         Reverse Traverse BufList      See previous notes.
===========================  ============================  ==============================================================================

You can also easily switch buffers by filename,
but you might find it easier to always use a
more general file-open command, like ``:CommandT``,
which is mapped to ``<Ctrl-D>`` (see later section).

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``:b filena<CR>``            Switch to Buffer
                              by (partial) Name
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``:ls``                      List buffer numbers           Hint: ``map <S-F2> :ls<CR>:b<Space>`` is a nifty switcheroo.
                              and names
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Shift-F2>``               Show buffer list and          Calls ``:ls<CR>:b<Space>`` so you can see the list of buffers and
                              prompt for number             then either type a buffer name or type (part of) a filename
                              or (partial) name             followed by <enter> to switch buffers.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``__``                       Show buffer list prompt       Similar to ``<Shift-F2>``, but simpler.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Shift-Alt-2>``            Toggle ``:netrw``             This toggles the ``:netrw`` Explorer window.
===========================  ============================  ==============================================================================

Dubs Vim Window Commands
------------------------

These are window commands custom to Dubs Vim.

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Ctrl-Shift-Up>``          Move Cursor to Window         Moves the cursor to the window above the current window,
                              Above or Leftward             or the window to the left.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Ctrl-Shift-Down>``        Move Cursor to Window         Moves the cursor to the window to the right of
                              to Right or Below             or below the current window.
===========================  ============================  ==============================================================================

Common Window Commands
----------------------

These are commonly-used window commands that are part of Vim
(that is, these commands are not specific to Dubs Vim).
This is just a refresher...

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Alt-w>c``                 Close Window                  Closes the window that the cursor is in.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Alt-w>o``                 "Only" Window                 Closes all window except the one containing the cursor.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Alt-w>p``                 Horizontal Split              Creates a new window by splitting the current window in half along the horizon.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Alt-w>s``                 Vertical Split                Creates a new window by splitting the current window in half along the vertical
                                                            axis. Hint: If you want to compare two files side-by-side, open one file and
                                                            then then other file, hit ``<Alt-w>s`` to split the window, and then hit
                                                            ``<F2>`` to jump to the first buffer; now you're looking at both buffers.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Ctrl-w><Shift-L>``        Move Window to the Left       Hint: If you have two windows split horizontally and the cursor is in the
                                                            right window, use ``<Ctrl-W><Shift-L>`` to essentially swap windows, so the
                                                            left-side window and buffer will now be on the right, and vice versa.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Ctrl-w><Shift-R>``        Move Window to the Right      Opposite of ``<Ctrl-W><Shift-L>``: If you have the cursor in the left-most window,
                                                            swap positions with the right-most window, if you've got two horizontally
                                                            split windows showing.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Ctrl-w><Shift-J/-K>``     Move Window Down or Up        Like the last two commands but useful when the two windows are split vertically.
===========================  ============================  ==============================================================================

Dubs Vim Tab Commands
---------------------

These are tab commands custom to Dubs Vim.

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``<Alt-PageUp>``             Switch Tabs                   Changes to the next tab.
                                                            I [lb] almost never uses tabs in Vim -- the exception being ``:TabMessage``.
                                                            But if you use tabs, ``<Alt-PageUp>`` and ``<Alt-PageDown>``
                                                            can be used to iterate through the list of tabs.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``<Alt-PageDown>``           Switch Tabs                   The opposite of ``<Alt-PageUp>``; changes to previous tab.
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

