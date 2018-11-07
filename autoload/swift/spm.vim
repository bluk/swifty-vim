" Vim autoload file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Functions related to running Swift Package Manager.

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

if !exists("g:swift_compiler_spm_path")
  let g:swift_compiler_spm_path = "swift"
endif

let s:format=",%E%f:%l:%c: error: %m"
let s:format.=",%W%f:%l:%c: warning: %m"
let s:format.=",%E%f:%l: error: %.%# : %m"
let s:format.=",%W%f:%l: warning: %.%# : %m"
let s:format.=",%-G%.%#"

function! swift#spm#Build(...) abort
  let l:opts = (a:0 > 0) ? copy(a:1) : {}

  let l:filename = expand('%')
  if expand('%:p') =~# '.*Tests.*'
    if !has_key(l:opts, 'only_compile')
      let l:opts.only_compile = 1
    endif

    let l:args = [l:opts]
    call extend(l:args, a:000[1:])

    call call('swift#spm#Test', l:args)
  elseif l:filename =~# '^\f\+\.swift$'
    let l:args = [l:opts]
    call extend(l:args, a:000[1:])

    call call('swift#spm#SourceBuild', l:args)
  endif
endfunction

function! swift#spm#SourceBuild(...) abort
  let l:opts = (a:0 > 0) ? copy(a:1) : {}
  let l:jump_to_error = has_key(l:opts, 'jump_to_error') ? l:opts.jump_to_error
        \ : g:swift_jump_to_error

  let l:args = ['build'] + map(copy(a:000[1:]), "expand(v:val)")

  let l:list_title = "SwiftBuild"
  let l:list_type = swift#list#Type(l:list_title)
  call swift#job#Spawn({
        \ 'cmd': [g:swift_compiler_spm_path] + l:args,
        \ 'jump_to_error': l:jump_to_error,
        \ 'list_title': l:list_title,
        \ 'list_type': l:list_type,
        \ 'status_type': 'build',
        \ 'job_dir': swift#spm#FindPackageSwiftDir(),
        \})
endfunction

function! swift#spm#Test(...) abort
  let l:opts = (a:0 > 0) ? copy(a:1) : {}
  let l:jump_to_error = has_key(l:opts, 'jump_to_error') ? l:opts.jump_to_error
        \ : g:swift_jump_to_error
  let l:only_compile = has_key(l:opts, 'only_compile') ? l:opts.only_compile : 0

  if l:only_compile == 1
    let l:args = ["build", "--build-tests"]
  else
    let l:args = ["test"]
  endif

  call extend(l:args, map(copy(a:000[1:]), "expand(v:val)"))

  let l:list_title = "SwiftTest"
  let l:list_type = swift#list#Type(l:list_title)
  call swift#job#Spawn({
        \ 'cmd': [g:swift_compiler_spm_path] + l:args,
        \ 'jump_to_error': l:jump_to_error,
        \ 'list_title': l:list_title,
        \ 'list_type': l:list_type,
        \ 'status_type': l:only_compile ? 'compile test' : 'test',
        \ 'errorformat': s:format,
        \ 'job_dir': swift#spm#FindPackageSwiftDir(),
        \ })
endfunction

function! swift#spm#TestFunctionOnly(opts, ...) abort
  let l:opts = (a:0 > 0) ? copy(a:1) : {}

  let l:line_number = search('func\s\+\(test\)', "bcnW")

  if l:line_number == 0
    call swift#echo#EchoWarning('[test] No test found immediately before cursor.')
    return
  endif

  let l:line_contents = getline(l:line_number)
  let l:test_name = split(split(l:line_contents, " ")[1], "(")[0]

  let l:args = [l:opts, "--filter", l:test_name]

  call extend(l:args, a:000[1:])

  call call('swift#spm#Test', l:args)
endfunction

function! swift#spm#TestGenerateLinuxMain(...) abort
  let l:opts = (a:0 > 0) ? copy(a:1) : {}
  let l:jump_to_error = has_key(l:opts, 'jump_to_error') ? l:opts.jump_to_error
        \ : g:swift_jump_to_error

  let l:args = ["test", "--generate-linuxmain"]
  call extend(l:args, map(copy(a:000[1:]), "expand(v:val)"))

  let l:list_title = "SwiftTest"
  let l:list_type = swift#list#Type(l:list_title)
  call swift#job#Spawn({
        \ 'cmd': [g:swift_compiler_spm_path] + l:args,
        \ 'jump_to_error': l:jump_to_error,
        \ 'list_title': l:list_title,
        \ 'list_type': l:list_type,
        \ 'status_type': 'test generate-linuxmain',
        \ 'errorformat': s:format,
        \ 'job_dir': swift#spm#FindPackageSwiftDir(),
        \ })
endfunction

function! swift#spm#GenerateXcodeProject(...) abort
  let l:opts = (a:0 > 0) ? copy(a:1) : {}
  let l:jump_to_error = has_key(l:opts, 'jump_to_error') ? l:opts.jump_to_error
        \ : g:swift_jump_to_error

  let l:command = [g:swift_compiler_spm_path, 'package', 'generate-xcodeproj']
  call extend(l:command, map(copy(a:000[1:]), "expand(v:val)"))

  let l:current_dir = getcwd()
  let l:cd = exists('*haslocaldir') && haslocaldir() ? 'lcd' : 'cd'
  try
    execute l:cd expand('%:p:h')
    silent let l:out = systemlist(join(l:command, " "))
    if v:shell_error == 0
      call swift#echo#EchoSuccess(l:out)
    else
      call swift#echo#EchoError(l:out)
    endif
  finally
    execute l:cd fnameescape(l:current_dir)
  endtry
endfunction

function! swift#spm#FindPackageSwiftDir() abort
  let l:package_swift = findfile("Package.swift", expand('%:p:h') . ";")
  if empty(l:package_swift)
    return ""
  endif
  return fnamemodify(l:package_swift, ':p:h')
endfunction

" vim: sw=2 ts=2 et
