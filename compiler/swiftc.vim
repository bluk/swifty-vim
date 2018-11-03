" Vim compiler file
" Language:         Swift
" Compiler:         Swiftc Compiler
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Swiftc compiler options and errorformat.

"  Copyright 2018 Bryant Luk
"
"  Licensed under the Apache License, Version 2.0 (the "License");
"  you may not use this file except in compliance with the License.
"  You may obtain a copy of the License at
"
"  http://www.apache.org/licenses/LICENSE-2.0
"
"  Unless required by applicable law or agreed to in writing, software
"  distributed under the License is distributed on an "AS IS" BASIS,
"  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
"  See the License for the specific language governing permissions and
"  limitations under the License.

if exists("current_compiler")
  finish
endif
let current_compiler = "swiftc"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

if !exists("g:swift_compiler_swiftc_path")
  let g:swift_compiler_swiftc_path = "swiftc"
endif

if !exists("g:swift_compiler_swiftc_options")
  let g:swift_compiler_swiftc_options = ""
endif

if !exists("g:swift_compiler_swiftc_makeprg_no_percent")
  let g:swift_compiler_swiftc_makeprg_no_percent = 0
endif

let s:save_cpoptions = &cpoptions
set cpoptions-=C

if g:swift_compiler_swiftc_makeprg_no_percent
  execute 'CompilerSet makeprg='
    \ . escape(g:swift_compiler_swiftc_path, ' ')
    \ . '\ '
    \ . escape(g:swift_compiler_swiftc_options, ' ')
else
  execute 'CompilerSet makeprg='
    \ . escape(g:swift_compiler_swiftc_path, ' ')
    \ . '\ '
    \ . escape(g:swift_compiler_swiftc_options, ' ')
    \ . '\ $*\ %'
endif

CompilerSet errorformat=
  \%E%f:%l:%c:\ error:\ %m,
  \%W%f:%l:%c:\ warning:\ %m,
  \%E%f:%l:\ error:\ %m,
  \%W%f:%l:\ warning:\ %m,
  \%-G%.%#

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

" vim: sw=2 ts=2 et
