" Vim plugin file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Plugin settings for swifty-vim.

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

if exists("g:swift_loaded")
    finish
endif
let g:swift_loaded = 1

if !exists("g:swift_version_check")
  let g:swift_version_check = 1
endif

function s:check_version() abort
  if g:swift_version_check == 0
    return
  endif

  let l:is_unsupported = (v:version < 800 || (v:version == 800 && !has("patch0902")))
  if l:is_unsupported == 1
    echohl Error
    echom "swifty-vim requires Vim 8.0.0902, but it seems you are using an older version."
    echom "Please upgrade Vim to use all of the features."
    echom ""
    echom "You can disable this message by setting:"
    echom "    let g:swift_version_check = 0"
    echohl None

    sleep 2
  endif
endfunction

call s:check_version()

augroup swiftyvim.events
  autocmd!

  autocmd BufWritePre *.swift call swift#autosave#Start()
  autocmd BufWritePre *.swift call swift#swiftformat#PreWrite()
  autocmd BufWritePost *.swift call swift#swiftlint#PostWrite()
augroup end

" vim: sw=2 ts=2 et
