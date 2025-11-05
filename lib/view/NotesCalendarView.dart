import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:meal_ver2/viewmodel/MainViewModel.dart';
import 'package:meal_ver2/view/NotesListView.dart';

class NotesCalendarView extends StatefulWidget {
  @override
  _NotesCalendarViewState createState() => _NotesCalendarViewState();
}

class _NotesCalendarViewState extends State<NotesCalendarView> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  // Get events (notes) for a specific day
  List<int> _getEventsForDay(DateTime day, MainViewModel viewModel) {
    final count = viewModel.getNotesCountForDate(day);
    return count > 0 ? [count] : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '노트 캘린더',
          style: TextStyle(fontFamily: 'Mealfont'),
        ),
        actions: [
          // Today button
          IconButton(
            icon: Icon(Icons.today),
            tooltip: '오늘',
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              TableCalendar(
                locale: 'ko',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                eventLoader: (day) => _getEventsForDay(day, viewModel),

                // Styling
                calendarStyle: CalendarStyle(
                  // Today's decoration
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  // Selected day decoration
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  // Marker decoration (event dots)
                  markerDecoration: BoxDecoration(
                    color: Colors.yellow.shade700,
                    shape: BoxShape.circle,
                  ),
                  markerSize: 6.0,
                  markerMargin: EdgeInsets.symmetric(horizontal: 0.5),
                  markersMaxCount: 1,

                  // Weekend colors
                  weekendTextStyle: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Mealfont',
                  ),
                  defaultTextStyle: TextStyle(
                    fontFamily: 'Mealfont',
                  ),
                  outsideTextStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontFamily: 'Mealfont',
                  ),
                ),

                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextFormatter: (date, locale) => DateFormat.yMMMM('ko').format(date),
                  titleTextStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Mealfont',
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),

                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontFamily: 'Mealfont',
                    fontWeight: FontWeight.bold,
                  ),
                  weekendStyle: TextStyle(
                    fontFamily: 'Mealfont',
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),

                // Callbacks
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  // Navigate to notes list for selected day
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NotesListView(date: selectedDay),
                    ),
                  );
                },

                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },

                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
