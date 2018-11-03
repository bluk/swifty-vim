" Vim ftdetect file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Detects Swift files.

" Source code modified from original file:
" https://github.com/apple/swift/blob/11874988289e2afb443a156dae45aedb3f5fd1b7/utils/vim/ftdetect/swift.vim
"
" This source file was originally part of the Swift.org open source project
"
" Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
" Licensed under Apache License v2.0 with Runtime Library Exception
"
" See https://swift.org/LICENSE.txt for license information
" See https://swift.org/CONTRIBUTORS.txt for the list of Swift project
" authors

" vint: -ProhibitAutocmdWithNoGroup
autocmd BufNewFile,BufRead *.swift set filetype=swift

" vim: sw=2 ts=2 et
