List<int> _normalize(List<int> verseNumbers) {
  final unique = verseNumbers.toSet().toList();
  unique.sort();
  return unique;
}

String formatVerseRange(List<int> verseNumbers) {
  if (verseNumbers.isEmpty) return '';

  final numbers = _normalize(verseNumbers);
  final ranges = <String>[];
  int start = numbers.first;
  int end = start;

  for (int i = 1; i < numbers.length; i++) {
    final current = numbers[i];
    if (current == end + 1) {
      end = current;
    } else {
      ranges.add(_segment(start, end));
      start = current;
      end = current;
    }
  }

  ranges.add(_segment(start, end));
  return ranges.join(', ');
}

String _segment(int start, int end) {
  return start == end ? '$start' : '$start-$end';
}
