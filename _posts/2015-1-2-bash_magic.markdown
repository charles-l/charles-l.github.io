---
layout: post
title: bash magic
date: 2015-01-02
---

Bash has a bunch of features that are (somewhat) undocumented but are extremely powerful. There are magic variables, shortcuts and shorthands that can help you improve your shell-fu. This post is a compilation of some of the best features Bash has to offer (many of which apply to  zsh as well).

# Shortcuts
* `Ctrl E`: Move cursor to the end of the current command.
* `Ctrl A`: Move cursor to the beginning of the current command.
* `Ctrl U`: Delete to beginning of command from current cursor position.
* `Ctrl K`: Delete to end of command from current cursor position.
* `Ctrl R`: Reverse search history
* `Ctrl X Ctrl-E`: Open the current command in $EDITOR (very useful for long commands).
* `Ctrl -`: Incremental undo
* `Ctrl L`: Clear screen to the top (same thing as `clear` command)

# Shorthands and Magic variables
* `!!`: The last command
* `!$`: The last argument from the last command.
* `![word]`: The last command starting with *[word]*
* `![word]:p`: Print the last command starting with *[word]* (but do not run)
* `^[word]^[replacement]`: Find last command starting with *[word]* and re-run it with *[replacement]*.
* `[command] [argument]{a,b,c}`: Run *[command]* with *[argument]* three times, each time changing the postfix to `a`, then `b`, then `c`. For example, `mkdir test{1,2}` would make two directories: `test1` and `test2`
* `set -o vi`: Use vi-like movement to edit commands :)

# PS1 Variables for Prompt Customization
* `\t`: Time (HH:MM:SS)
* `\d`: Date (Weekday Month Day)
* `\w`: pwd
* `\W`: basename of pwd
* `\u`: username
* `\h`: hostname
