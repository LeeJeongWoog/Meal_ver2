## Codebase Organization & Refactoring Suggestions

1. **Modularize viewmodels and services**
   - Split `MainViewModel` into smaller classes (notes, highlights, preferences, bible loading) under `lib/viewmodel/` or `lib/service/`. This reduces the 900+ line file and makes unit testing more targeted.
   - Extract data-access helpers (SharedPreferences, Firebase, HTTP) into dedicated repositories so the viewmodels can focus on state.

2. **Adopt feature-first folder structure inside `lib/view/`**
   - Group related widgets (e.g., notes, highlights, reader) into subfolders (`view/notes/NotesListView.dart`, `view/notes/NoteEditorView.dart`, etc.) to clarify ownership and simplify imports.
   - Co-locate viewmodels and models for each feature via folders (`notes/model`, `notes/viewmodel`, `notes/view`) while keeping shared artifacts (Theme, util, firebase) at the root.

3. **Refine note-related widgets**
   - Break large widgets like `Meal2View` and `NotesListView` into smaller stateless components (headers, cards, empty states) to reduce nesting depth and improve readability.
   - Define reusable buttons/menus for note actions to keep behavior consistent between calendar/list screens.

4. **Centralize copy/share formatting**
   - Move the clipboard formatting logic into a dedicated utility/service that both viewmodels and views can import, ensuring a single source of truth for verse/notes string generation.
   - Provide integration tests around this service to catch regressions without spinning up UI.

5. **Strengthen testing layout**
   - Mirror the `lib/` structure in `test/` so each feature folder has its own test suite (`test/notes/note_model_test.dart`, `test/notes/verse_range_formatter_test.dart`).
   - Add widget tests for notes list/editor to validate UI-only refactors without manual QA.
