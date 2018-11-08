" Vim autoload file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Functions related to running SwiftFormat.

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

if !exists("g:swift_swiftformat_path")
  let g:swift_swiftformat_path = "swiftformat"
endif

if !exists("g:swift_swiftformat_autosave")
  let g:swift_swiftformat_autosave = 0
endif

if !exists("g:swift_swiftformat_config_file_path")
  let g:swift_swiftformat_config_file_path = ""
endif

if !exists("g:swift_swiftformat_config_file_name")
  let g:swift_swiftformat_config_file_name = ".swiftformat"
endif

if !exists("g:swift_swiftformat_config_file_search_parent_dir")
  let g:swift_swiftformat_config_file_search_parent_dir = 1
endif

if !exists("g:swift_swiftformat_fail_silently")
  let g:swift_swiftformat_fail_silently = 0
endif

if !exists("g:swift_swiftformat_options")
  let g:swift_swiftformat_options = []
endif

let s:list_title = "SwiftFormat"

let s:format="%E%f:error: %m at %l:%c"
let s:format.=",%W%f:warning: %m at %l:%c"
let s:format.=",%E%f:error: %m"
let s:format.=",%W%f:warning: %m"
let s:format.=",%-G%.%#"

function! swift#swiftformat#Format(...) abort
  let l:opts = (a:0 > 0) ? copy(a:1) : {}
  let l:jump_to_error = has_key(l:opts, 'jump_to_error') ? l:opts.jump_to_error
        \ : g:swift_jump_to_error
  let l:on_autosave = has_key(l:opts, 'on_autosave') ? l:opts.on_autosave : 0

  let l:list_should_clean = !l:on_autosave && g:swift_list_clean
  let l:list_type = swift#list#Type(s:list_title, l:on_autosave)

  if l:list_should_clean
    call swift#list#Clean(l:list_type)
  endif

  mkview!

  let current_col = col('.')
  let diff_offset = 0

  let l:winid = win_getid(winnr())

  let l:output_tmpname = tempname()
  let l:stderr_tmpname = tempname()

  let l:command = s:format_cmd(g:swift_swiftformat_path, l:output_tmpname)
  call extend(l:command, map(copy(a:000[1:]), "expand(v:val)"))
  call extend(l:command, [' 2> ', l:stderr_tmpname])

  let l:buffer = getline(1, '$')
  silent let out = systemlist(join(l:command, " "), l:buffer)

  let l:stderr = readfile(l:stderr_tmpname)
  call delete(l:stderr_tmpname)

  if v:shell_error == 0
    try | silent undojoin | catch | endtry

    let l:content = readfile(l:output_tmpname)
    let diff_offset = len(l:content) - line('$')

    silent! execute '%!cat ' . l:output_tmpname

    if empty(swift#list#Get(l:list_type))
      call swift#list#Close(l:list_type)
    endif

    silent! loadview

    call cursor(line('.') + diff_offset, current_col)
  elseif !g:swift_swiftformat_fail_silently
    " Add 1 to the column value of the SwiftFormat error output.
    let l:stderr = map(copy(l:stderr), 'substitute(v:val, "\\(.* at \\d\\+:\\)\\(\\d\\+\\)", "\\=(submatch(1)) . (submatch(2) + 1)", "g")')
    " Hack in the filename to the beginning of the error output.
    let l:stderr = map(copy(l:stderr), "'" . expand('%') . ":'" . ' . v:val')

    call swift#list#ParseFormat(l:list_type, s:format, l:stderr, s:list_title, l:on_autosave)
    let errors = swift#list#Get(l:list_type)
    if empty(errors)
      call swift#echo#EchoError(l:stderr)
      silent! loadview
    else
      call swift#list#Window(l:list_type, len(errors))
      call win_gotoid(l:winid)
      silent! loadview
      if l:jump_to_error
        call swift#list#JumpToFirst(l:list_type)
      else
        call win_gotoid(l:winid)
      endif
    endif
  else
    silent! loadview
  endif

  call delete(l:output_tmpname)
endfunction

function! swift#swiftformat#PreWrite() abort
  if get(g:, "swift_swiftformat_autosave", 0)
    let l:list_type = swift#list#Type(s:list_title, 1)
    call swift#autosave#CleanIfNeeded(l:list_type)
    call swift#swiftformat#Format({ "on_autosave": 1 })
  endif
endfunction

function! s:format_cmd(bin_name, target) abort
  let l:cmd = [a:bin_name]

  let l:config_file = s:find_config()
  if !empty(l:config_file)
    call extend(l:cmd, ["--config", l:config_file])
  endif

  call extend(l:cmd, g:swift_swiftformat_options)

  if !empty(a:target)
    call extend(l:cmd, ["--output", a:target])
  endif

  return l:cmd
endfunction

function! s:find_config() abort
  if !empty(g:swift_swiftformat_config_file_path)
    return g:swift_swiftformat_config_file_path
  endif

  if !g:swift_swiftformat_config_file_search_parent_dir
    return ""
  endif

  let l:format_config = findfile(g:swift_swiftformat_config_file_name, expand('%:p:h') . ";")
  if empty(l:format_config)
    return ""
  endif
  return fnamemodify(l:format_config, ':p')
endfunction

" vim: sw=2 ts=2 et
