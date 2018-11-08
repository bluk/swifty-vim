" Vim autoload file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Functions related to running SwiftLint.

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

if !exists("g:swift_swiftlint_path")
  let g:swift_swiftlint_path = "swiftlint"
endif

if !exists("g:swift_swiftlint_autosave")
  let g:swift_swiftlint_autosave = 0
endif

if !exists("g:swift_swiftlint_config_file_path")
  let g:swift_swiftlint_config_file_path = ""
endif

if !exists("g:swift_swiftlint_config_file_name")
  let g:swift_swiftlint_config_file_name = ".swiftlint.yml"
endif

if !exists("g:swift_swiftlint_config_file_search_parent_dir")
  let g:swift_swiftlint_config_file_search_parent_dir = 1
endif

if !exists("g:swift_swiftlint_options")
  let g:swift_swiftlint_options = []
endif

if !exists("g:swift_swiftlint_from_package")
  let g:swift_swiftlint_from_package = 0
endif

let s:list_title = "SwiftLint"

let s:format=",%E%f:%l:%c: error: %m"
let s:format.=",%W%f:%l:%c: warning: %m"
let s:format.=",%E%f:%l: error: %m"
let s:format.=",%W%f:%l: warning: %m"
let s:format.=",%-G%.%#"

function! swift#swiftlint#Lint(...) abort
  let l:opts = (a:0 > 0) ? copy(a:1) : {}
  let l:jump_to_error = has_key(l:opts, 'jump_to_error') ? l:opts.jump_to_error
        \ : g:swift_jump_to_error
  let l:on_autosave = has_key(l:opts, 'on_autosave') ? l:opts.on_autosave : 0

  let l:list_should_clean = !l:on_autosave && g:swift_list_clean
  let l:list_type = swift#list#Type(s:list_title, l:on_autosave)

  if l:list_should_clean
    call swift#list#Clean(l:list_type)
  endif

  let l:args = []

  if g:swift_swiftlint_from_package
    let l:job_dir = swift#spm#FindPackageSwiftDir()
  else
    let l:config_file = s:find_config()
    let l:job_dir = fnamemodify(l:config_file, ':h')
    if !empty(l:config_file)
      call extend(l:args, ["--config", l:config_file])
    endif
  endif

  call extend(l:args, g:swift_swiftlint_options)

  if !g:swift_swiftlint_from_package
    call extend(l:args, ["--path", expand('%:p')])
  endif

  call extend(l:args, map(copy(a:000[1:]), "expand(v:val)"))

  if l:on_autosave
    redraw
  endif

  call swift#job#Spawn({
        \ 'cmd' : [g:swift_swiftlint_path] + l:args,
        \ 'jump_to_error': l:jump_to_error,
        \ 'on_autosave': l:on_autosave,
        \ 'list_title': s:list_title,
        \ 'list_type': l:list_type,
        \ 'status_type': "swiftlint",
        \ 'errorformat': s:format,
        \ 'job_dir': l:job_dir,
        \ })
endfunction

function! swift#swiftlint#PostWrite() abort
  if get(g:, "swift_swiftlint_autosave", 0)
    let l:list_type = swift#list#Type(s:list_title, 1)
    call swift#autosave#CleanIfNeeded(l:list_type)
    call swift#swiftlint#Lint({ "on_autosave": 1 })
  endif
endfunction

function! s:find_config() abort
  if !empty(g:swift_swiftlint_config_file_path)
    return g:swift_swiftlint_config_file_path
  endif

  if !g:swift_swiftlint_config_file_search_parent_dir
    return ""
  endif

  let l:lint_config = findfile(g:swift_swiftlint_config_file_name, expand('%:p:h') . ";")
  if empty(l:lint_config)
    return ""
  endif
  return fnamemodify(l:lint_config, ':p')
endfunction

" vim: sw=2 ts=2 et
