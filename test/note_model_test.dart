import 'package:flutter_test/flutter_test.dart';
import 'package:meal_ver2/model/Note.dart';

void main() {
  VerseReference buildRef(int verse) => VerseReference(
        bibleType: 'KRV',
        book: '창세기',
        chapter: 1,
        verse: verse,
        text: '태초에 하나님이 천지를 창조하시니라 $verse',
      );

  group('Note', () {
    test('create() stores a defensive copy of selected verses', () {
      final selected = [buildRef(1), buildRef(2)];

      final note = Note.create(
        date: DateTime(2024, 1, 1),
        title: '창세기',
        content: '메모',
        selectedVerses: selected,
      );

      selected.clear(); // Mutate original list

      expect(note.selectedVerses, isNot(same(selected)));
      expect(note.selectedVerses, hasLength(2));
      expect(note.selectedVerses.first.verse, 1);
    });

    test('copyWith() copies provided selected verses list', () {
      final base = Note.create(
        date: DateTime(2024, 1, 1),
        title: '창세기',
        content: '메모',
        selectedVerses: [buildRef(1)],
      );
      final updatedSelection = [buildRef(3)];

      final updated = base.copyWith(selectedVerses: updatedSelection);

      updatedSelection.clear(); // Should not affect note

      expect(updated.selectedVerses, isNot(same(updatedSelection)));
      expect(updated.selectedVerses.single.verse, 3);
    });
  });
}
