## [0.4.1] 2026-09-14

- Clearly mark today
- Set text color for all link states

## [0.4.0] 2026-08-05

- `Formatic::File` now raises at render time when `attribute_name` does not exist on the model, so typos like `header_logo_for_light` (instead of the model's `header_logo_for_dark`) surface immediately instead of silently dropping the upload. The check is skipped when a manual `value:` is passed, the form builder has no object, or the object is not an ActiveModel/ActiveRecord record.

## [0.3.0] 2026-08-04

- Make VS Code snippet symlinking atomic so concurrent app boots no longer race into `Errno::EEXIST`

## [0.2.12] 2026-07-24

- Add data attribute to every input

## [0.2.11] 2026-07-22

- More robust vscode snippet symlinking

## [0.2.10] 2026-06-03

- Fix Stepper and placeholder colors

## [0.2.9] - 2026-05-26

- Fix vscode snippet file symlink mechanism

## [0.2.7] - 2026-04-29

- Fix rails complaining about require'ing action_view too early

## [0.2.6] - 2026-03-31

- Improvement: Use native dark mode scheme instead of fixed colors
- Filepond fixes (validations, non-direct upload)

## [0.2.5] - 2026-02-04

- Add accept mime for files

## [0.1.2] - 2025-03-23

- Add experimental dark theme (in particular for <textarea>)

## [0.1.1] - 2025-03-23

- Fix a load error

## [0.1.0] - 2025-03-23

- Initial release
