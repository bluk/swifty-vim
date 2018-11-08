" Vim ftplugin file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Filetype plugin settings for Swift.

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

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

if !exists("g:swift_jump_to_error")
  let g:swift_jump_to_error = 1
endif

if !exists("g:swift_list_clean")
  let g:swift_list_clean = 1
endif

if !exists("g:swift_list_clean_on_autosave")
  let g:swift_list_clean_on_autosave = 1
endif

if !exists("g:swift_compiler_spm_path")
  let g:swift_compiler_spm_path = "swift"
endif

setlocal comments=s1:/*,mb:*,ex:*/,:///,://
setlocal commentstring=//\ %s

augroup swiftyvim
  autocmd!

  if strlen(findfile("Package.swift", expand('%:p:h') . ";")) > 0
    compiler spm
  else
    compiler swiftc
  endif
augroup end

" vim: sw=2 ts=2 et
