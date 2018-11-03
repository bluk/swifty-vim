# ⌨️ swifty-vim

A [Vim][vim] plugin for [Swift][swift] which provides
file detection, syntax highlighting, support for compiling and
running tests, and optional support for formatting and linting tools.

It is inspired by [vim-go][vim-go] and [rust.vim][rust_vim].

## Requirements

* Vim 8.0.0902 or greater
* [Swift Toolchain][swift_toolchain_install] or Xcode
* (Optional) [SwiftFormat][swiftformat]
* (Optional) [SwiftLint][swiftlint]

## Installation

Use one of the following package managers:

* [Vim 8 packages][vim8pack]:
  * `git clone https://github.com/bluk/swifty-vim ~/.vim/pack/plugins/start/swifty-vim`
* [Pathogen][pathogen]:
  * `git clone --depth=1 https://github.com/bluk/swifty-vim.git ~/.vim/bundle/swifty-vim`
* [vim-plug][vim-plug]:
  * Add `Plug 'bluk/swifty-vim'` to `~/.vimrc`
  * `:PlugInstall` or `$ vim +PlugInstall +qall`
* [dein.vim][dein.vim]:
  * Add `call dein#add('bluk/swifty-vim')` to `~/.vimrc`
  * `:call dein#install()`
* [Vundle][vundle]:
  * Add `Plugin 'bluk/swifty-vim'` to `~/.vimrc`
  * `:PluginInstall` or `$ vim +PluginInstall +qall`

## Features

There are configuration options to customize the behavior of the key mappings
and commands.

### Swift Package Manager Support

Key mappings and commands such as:

* `:SwiftPMBuild` to build the current package source or tests.
* `:SwiftPMTest` to run the package tests.
* `:SwiftPMTestFunctionOnly` to run the current test under the cursor.

### SwiftFormat Support

Key mapping and command:

* `:SwiftFormat` to format the current file.

### SwiftLint Support

Key mapping and command:

* `:SwiftLint` to lint the current file.

## Sample vimrc Configuration

Add the following to your `vimrc`:

```vim
" Build the current Swift package. If in a 'Tests' directory, also build the tests.
autocmd FileType swift nmap <leader>b <Plug>(swift-spm-build)
" Run the current Swift package tests.
autocmd FileType swift nmap <leader>t <Plug>(swift-spm-test)
" Run the test under the current cursor.
autocmd FileType swift nmap <leader>ft <Plug>(swift-spm-test-function-only)

" Run SwiftFormat on save.
let g:swift_swiftformat_autosave = 1
" Run SwiftLint on save.
let g:swift_swiftlint_autosave = 1
```

## Documentation / Help

Help can be found in the included [documentation][doc_dir].

Run `:help swifty-vim` in Vim. Helptags (`:Helptags`) may need to be generated for navigation. See your
plugin manager or the helptags documentation (`:help helptags`) for more information.

## License

[Apache-2.0 License][license]

[license]: LICENSE
[swift]: https://swift.org
[vim]: https://www.vim.org
[vim-go]: https://github.com/fatih/vim-go
[rust_vim]: https://github.com/rust-lang/rust.vim/
[swift_toolchain_install]: https://swift.org/getting-started/
[swiftformat]: https://github.com/nicklockwood/SwiftFormat
[swiftlint]: https://github.com/realm/SwiftLint
[vim8pack]: http://vimhelp.appspot.com/repeat.txt.html#packages
[pathogen]: https://github.com/tpope/vim-pathogen
[vim-plug]: https://github.com/junegunn/vim-plug
[dein.vim]: https://github.com/Shougo/dein.vim
[vundle]: https://github.com/gmarik/vundle
[doc_dir]: doc/
