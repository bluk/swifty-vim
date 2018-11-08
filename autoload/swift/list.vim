" Vim autoload file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Functions to interact with locationlist and quickfix list.

" Source code modified from original file:
" https://github.com/fatih/vim-go/blob/dee5fe4f65ea8d7bdd2ff87a1675743f91bdd297/autoload/go/list.vim
"
" Copyright (c) 2015, Fatih Arslan
" All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
"
" * Redistributions of source code must retain the above copyright notice, this
"   list of conditions and the following disclaimer.
"
" * Redistributions in binary form must reproduce the above copyright notice,
"   this list of conditions and the following disclaimer in the documentation
"   and/or other materials provided with the distribution.
"
" * Neither the name of vim-go nor the names of its
"   contributors may be used to endorse or promote products derived from
"   this software without specific prior written permission.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
" FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
" SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
" CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
" OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
" OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if !exists("g:swift_list_autoclose")
  let g:swift_list_autoclose = 1
endif

if !exists("g:swift_list_height")
  let g:swift_list_height = 0
endif

if !exists("g:swift_list_type_commands")
  let g:swift_list_type_commands = {}
endif

if !exists("g:swift_list_type")
  let g:swift_list_type = ""
endif

function! swift#list#Window(list_type, list_height, ...) abort
  if a:list_height == 0
    call s:close_list(a:list_type)
    return
  endif

  let l:height = g:swift_list_height
  if l:height == 0
    if a:list_height > 10
      let l:height = 10
    else
      let l:height = a:list_height
    endif
  endif

  if a:list_type ==# "locationlist"
    exe 'lopen ' . height
  else
    exe 'copen ' . height
  endif
endfunction

function! swift#list#Get(list_type) abort
  if a:list_type ==# "locationlist"
    return getloclist(0)
  else
    return getqflist()
  endif
endfunction

function! swift#list#ParseFormat(list_type, format, items, title, keep_existing_items) abort
  let old_errorformat = &errorformat
  let &errorformat = a:format

  try
    if a:list_type ==# "locationlist"
      if a:keep_existing_items
        let l:existing_items = getloclist(0)
        let l:existing_options = getloclist(0, { 'title': 1})
        let l:existing_title = has_key(l:existing_options, "title") ? l:existing_options.title : ""
      endif

      lgetexpr a:items

      if a:keep_existing_items && l:existing_title != ":    lex []"
        call setloclist(0, [], 'a', { 'title': l:existing_title . " / " . a:title })
      else
        call setloclist(0, [], 'a', { 'title': a:title })
      endif

      if a:keep_existing_items && len(l:existing_items) > 0
        call setloclist(0, l:existing_items, 'a')
      endif
    else
      if a:keep_existing_items
        let l:existing_items = getqflist()
        let l:existing_options = getqflist({ 'title': 1 })
        let l:existing_title = has_key(l:existing_options, "title") ? l:existing_options.title : ""
      endif

      cgetexpr a:items

      if a:keep_existing_items && l:existing_title != ":    cex []"
        call setqflist([], 'a', { 'title': l:existing_title . " / " . a:title })
      else
        call setqflist([], 'a', { 'title': a:title })
      endif

      if a:keep_existing_items && len(l:existing_items) > 0
        call setqflist(l:existing_items, 'a')
      endif
    endif
  finally
    let &errorformat = old_errorformat
  endtry
endfunction

function! swift#list#JumpToFirst(list_type) abort
  if a:list_type ==# "locationlist"
    ll 1
  else
    cc 1
  endif
endfunction

function! swift#list#Clean(list_type) abort
  if a:list_type ==# "locationlist"
    lex []
  else
    cex []
  endif

  call swift#list#Close(a:list_type)
endfunction

function! swift#list#Close(list_type) abort
  if !g:swift_list_autoclose
    return
  endif

  if a:list_type ==# "locationlist"
    lclose
  else
    cclose
  endif
endfunction

let s:default_list_type_commands = {
      \ "Autosave":                "",
      \ "SwiftFormat":             "locationlist",
      \ "SwiftLint":               "quickfix",
      \ "SwiftPMBuild":            "quickfix",
      \ "SwiftPMTest":             "quickfix",
      \ "_job":                    "locationlist",
      \ }

function! swift#list#Type(for, on_autosave) abort
  if !empty(g:swift_list_type)
    return g:swift_list_type
  endif

  if a:on_autosave
    let l:list_type = get(g:swift_list_type_commands, "Autosave")
    if empty(l:list_type)
      let l:list_type =  get(s:default_list_type_commands, "Autosave")
    endif
    if !empty(l:list_type)
      return l:list_type
    endif
  endif

  let l:list_type = get(g:swift_list_type_commands, a:for)
  if l:list_type ==# "0"
    return get(s:default_list_type_commands, a:for, "quickfix")
  endif
  return l:list_type
endfunction

" vim: sw=2 ts=2 et
