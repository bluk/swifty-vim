# CHANGELOG

## v0.2.0

### Added

* Mapping `<Plug>(swift-spm-generate-xcodeproj>` and command
  `:SwiftPMGenerateXcodeProject` to generate a Swift package's
  Xcode project.
* Mapping `<Plug>(swift-spm-test-generate-linuxmain>` and command
  `:SwiftPMTestGenerateLinuxMain` to generate the LinuxMain
  test code.
* When using the autosave options, the errors can be sent to the same list
  by setting `let g:swift_list_type_commands = { 'Autosave': 'quickfix' }`.
  You can use either `quickfix` or `locationlist`.

### Updated

* Modify list cleaning and closing behavior. Add option to not clean lists during
  manual command/mapping invocations by setting `let g:swift_list_clean = 0`.
  Add option to not clean lists during autosave operations by setting
  `let g:swift_list_clean_on_autosave = 0`. Default is to always clean lists.

## v0.1.0

### Added

* Initial implementation.
