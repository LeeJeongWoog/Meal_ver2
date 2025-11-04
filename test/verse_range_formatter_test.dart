import 'package:flutter_test/flutter_test.dart';
import 'package:meal_ver2/util/verse_range_formatter.dart';

void main() {
  test('formatVerseRange collapses consecutive numbers', () {
    expect(formatVerseRange([14, 15, 16]), '14-16');
    expect(formatVerseRange([1, 2]), '1-2');
  });

  test('formatVerseRange splits disjoint ranges', () {
    expect(formatVerseRange([1, 3, 4, 6, 7, 8]), '1, 3-4, 6-8');
  });

  test('formatVerseRange ignores duplicates', () {
    expect(formatVerseRange([5, 5, 6, 7, 7]), '5-7');
  });
}
