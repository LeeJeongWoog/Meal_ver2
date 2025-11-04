### Plan to fix note-selected-verse clearing
1. **Identify mutation sites**  
   - Confirm every call site that passes `selectedVerses` (e.g., `_createNoteFromSelection`, `NotesListView._editNote`) so we know where defensive copies are needed.

2. **Stop sharing the mutable list**  
   - Update `Note.create` and `Note.copyWith` to store `List<VerseReference>.from(...)` instead of the provided list reference.
   - When constructing `NoteEditorView` (create/edit paths), pass `List.unmodifiable`/`List.from` so the widget cannot mutate the caller’s list.

3. **Add regression coverage**  
   - Extend or add a unit test in `test/` that simulates creating and editing a note: mutate the original selection list after saving and ensure the note’s `selectedVerses` stays intact.

4. **Manual verification**  
   - Run the app, create a note, edit it, and confirm the selected verses persist.
