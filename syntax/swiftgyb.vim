" Vim syntax file
" Language: gyb on swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Syntax file for gyb on Swift.

" Source code modified from original file:
" https://github.com/apple/swift/blob/6044c97318f768a3971198545e8b6e7e6dd80d0c/utils/vim/syntax/swiftgyb.vim
"
" This source file was originally part of the Swift.org open source project
"
" Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
" Licensed under Apache License v2.0 with Runtime Library Exception
"
" See https://swift.org/LICENSE.txt for license information
" See https://swift.org/CONTRIBUTORS.txt for the list of Swift project
" authors

runtime! syntax/swift.vim
unlet b:current_syntax

syn include @Python syntax/python.vim
syn region pythonCode matchgroup=gybPythonCode start=+^ *%+ end=+$+ contains=@Python keepend
syn region pythonCode matchgroup=gybPythonCode start=+%{+ end=+}%+ contains=@Python keepend
syn match gybPythonCode /\${[^}]*}/
hi def link gybPythonCode CursorLineNr

let b:current_syntax = "swiftgyb"

" vim: sw=2 ts=2 et
