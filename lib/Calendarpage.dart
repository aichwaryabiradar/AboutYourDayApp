import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yourday/Selectionpage.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(30, 159, 234, 1),
      ),
      backgroundColor: Color.fromARGB(255, 181, 220, 255),
      body: Center(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Choose the date!',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gagalin-Regular',
                      color: Color.fromRGBO(30, 159, 234, 1),
                    ),
                  ),
                ),
                Container(
                  height: 400,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      // Navigate to the SelectionPage when a date is selected
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectionPage(
                            selectedDay: selectedDay,
                          ),
                        ),
                      );
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Aligns image to the left
                  children: [
                    Container(
                      width: screenSize.width * 0.7,
                      height: screenSize.height * 0.2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/secondfirst.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*class SelectionPage extends StatelessWidget {
  final DateTime selectedDay;

  const SelectionPage({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Date'),
        backgroundColor: Color.fromRGBO(30, 159, 234, 1),
      ),
      body: Center(
        child: Text(
          'You selected: ${selectedDay.toLocal()}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}*/
