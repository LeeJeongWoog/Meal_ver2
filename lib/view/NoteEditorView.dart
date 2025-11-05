import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:meal_ver2/model/Note.dart';
import 'package:meal_ver2/viewmodel/MainViewModel.dart';

class NoteEditorView extends StatefulWidget {
  final List<VerseReference> selectedVerses;
  final DateTime date;
  final Note? existingNote;

  const NoteEditorView({
    Key? key,
    required this.selectedVerses,
    required this.date,
    this.existingNote,
  }) : super(key: key);

  @override
  _NoteEditorViewState createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> {
  late TextEditingController _contentController;
  String? _selectedColor;
  final List<String> _colorOptions = [
    '#FFE5B4', // Peach
    '#E6E6FA', // Lavender
    '#F0E68C', // Khaki
    '#FFB6C1', // Light Pink
    '#B0E0E6', // Powder Blue
    '#DDA0DD', // Plum
  ];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.existingNote?.content ?? '');
    _selectedColor = widget.existingNote?.color;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final viewModel = Provider.of<MainViewModel>(context, listen: false);

    // Auto-generate title from verse references
    final autoTitle = widget.selectedVerses.map((v) => v.reference).join(', ');

    if (widget.existingNote != null) {
      // Update existing note
      final updatedNote = widget.existingNote!.copyWith(
        title: autoTitle,
        content: _contentController.text,
        selectedVerses: widget.selectedVerses,
        color: _selectedColor,
      );
      viewModel.updateNote(updatedNote);
    } else {
      // Create new note
      final newNote = Note.create(
        date: widget.date,
        title: autoTitle,
        content: _contentController.text,
        selectedVerses: widget.selectedVerses,
        color: _selectedColor,
      );
      viewModel.addNote(newNote);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy년 MM월 dd일', 'ko_KR').format(widget.date);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : null,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : null,
        title: Text(
          widget.existingNote != null ? '노트 수정' : '새 노트',
          style: TextStyle(
            fontFamily: 'Settingfont',
            color: isDark ? Colors.white : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: Text(
              '저장',
              style: TextStyle(
                fontFamily: 'Settingfont',
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date display
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey[800]
                    : Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                dateStr,
                style: TextStyle(
                  fontFamily: 'Mealfont',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : null,
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Selected verses section
            Text(
              '선택된 구절',
              style: TextStyle(
                fontFamily: 'Settingfont',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : null,
              ),
            ),
            SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark
                      ? Colors.grey[700]!
                      : Colors.grey.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.selectedVerses.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        '선택된 구절이 없습니다',
                        style: TextStyle(
                          fontFamily: 'Mealfont',
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(12),
                      itemCount: widget.selectedVerses.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        final verse = widget.selectedVerses[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              verse.fullReference,
                              style: TextStyle(
                                fontFamily: 'Mealfont',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              verse.text,
                              style: TextStyle(
                                fontFamily: 'Biblefont',
                                fontSize: 14,
                                color: isDark ? Colors.white : null,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
            SizedBox(height: 24),

            // Content input
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: '내용',
                labelStyle: TextStyle(
                  fontFamily: 'Settingfont',
                  color: isDark ? Colors.white70 : null,
                ),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(
                fontFamily: 'Mealfont',
                fontSize: 14,
                color: isDark ? Colors.white : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}