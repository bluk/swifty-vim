" Vim ftdetect file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Detects gyb on Swift files.

" Source code modified from original file:
" https://github.com/apple/swift/blob/6044c97318f768a3971198545e8b6e7e6dd80d0c/utils/vim/ftdetect/swiftgyb.vim
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
autocmd BufNewFile,BufRead *.swift.gyb set filetype=swiftgyb

" vim: sw=2 ts=2 et
