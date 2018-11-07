" Vim ftplugin file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Filetype plugin settings for swifty-vim mappings.

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

nnoremap <silent> <Plug>(swift-spm-build) :<C-u>call swift#spm#Build({})<CR>
nnoremap <silent> <Plug>(swift-spm-test) :<C-u>call swift#spm#Test({})<CR>
nnoremap <silent> <Plug>(swift-spm-test-function-only) :<C-u>call swift#spm#TestFunctionOnly({})<CR>
nnoremap <silent> <Plug>(swift-spm-generate-xcodeproj) :<C-u>call swift#spm#GenerateXcodeProject({})<CR>
nnoremap <silent> <Plug>(swift-spm-test-generate-linuxmain) :<C-u>call swift#spm#TestGenerateLinuxMain({})<CR>

nnoremap <silent> <Plug>(swift-swiftformat) :<C-u>call swift#swiftformat#Format({})<CR>
nnoremap <silent> <Plug>(swift-swiftlint) :<C-u>call swift#swiftlint#Lint({})<CR>

" vim: sw=2 ts=2 et
