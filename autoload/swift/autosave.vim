" Vim autoload file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Functions related to autosave.

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

function! swift#autosave#Start() abort
  let b:swift_autosave_internal_lists = {}
endfunction

function! swift#autosave#CleanIfNeeded(list_type) abort
  if !has_key(b:swift_autosave_internal_lists, a:list_type)
    if g:swift_list_clean_on_autosave
      call swift#list#Clean(a:list_type)
    endif
    let b:swift_autosave_internal_lists[a:list_type] = 1
  endif
endfunction
