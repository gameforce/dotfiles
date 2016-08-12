#!/bin/zsh
# Affects all files in the current directory and all subdirectories. 
# For example, it turns Serenity.Ogg into Serenity.ogg, no matter where it is under the current directory.
# First parenthetical matches current directory and all subdirectories
# second group matches filename sans extension
# third group matches extension. ${(L)3} transforms the extension to lowercase.

autoload zmv
zmv '(**/)(*).(*)' '$1$2.${(L)3}'
