" Vim ftplugin file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Filetype plugin settings for swifty-vim commands.

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

" -- swift package manager
command! -nargs=* SwiftPMBuild call swift#spm#Build({}, <f-args>)
command! -nargs=* SwiftPMSourceBuild call swift#spm#SourceBuild({}, <f-args>)
command! -nargs=* SwiftPMTest call swift#spm#Test({}, <f-args>)
command! -nargs=* SwiftPMTestBuild call swift#spm#Test({ "only_compile": 1 }, <f-args>)
command! -nargs=* SwiftPMTestFunctionOnly call swift#spm#TestFunctionOnly({}, <f-args>)

" -- swiftformat
command! -nargs=* SwiftFormat call swift#swiftformat#Format({}, <f-args>)

" -- swiftlint
command! -nargs=* SwiftLint call swift#swiftlint#Lint({}, <f-args>)

" vim: sw=2 ts=2 et
