" Vim autoload file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Utility functions to echo messages.

" Source code modified from original file:
" https://github.com/fatih/vim-go/blob/8b21b2dc67ea7c666fa3a8052c6062ae217ec0d9/autoload/go/util.vim
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
"
" Echo a message to the screen and highlight it with the group in a:hi.
"
" The message can be a list or string; every line with be :echomsg'd separately.
function! s:echo(msg, hi) abort
  let l:msg = []
  if type(a:msg) != type([])
    let l:msg = split(a:msg, "\n")
  else
    let l:msg = a:msg
  endif

  " Tabs display as ^I or <09>, so manually expand them.
  let l:msg = map(l:msg, 'substitute(v:val, "\t", "        ", "")')

  exe 'echohl ' . a:hi
  for line in l:msg
    echom "swifty-vim: " . line
  endfor
  echohl None
endfunction

function! swift#echo#EchoSuccess(msg) abort
  call s:echo(a:msg, 'None')
endfunction
function! swift#echo#EchoError(msg) abort
  call s:echo(a:msg, 'ErrorMsg')
endfunction
function! swift#echo#EchoWarning(msg) abort
  call s:echo(a:msg, 'WarningMsg')
endfunction

" vim: sw=2 ts=2 et
