import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          _buildYearNavigator(),
          _buildMonthNavigator(),
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildYearNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year - 1, _selectedDate.month, _selectedDate.day);
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        Text(
          DateFormat('yyyy').format(_selectedDate),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year+1, _selectedDate.month, _selectedDate.day);
            });
          },
          icon: const Icon(Icons.arrow_forward),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _selectedDate = DateTime.now();
            });
          },
          icon: const Icon(Icons.today),
        ),
      ],
    );
  }

  Widget _buildMonthNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, _selectedDate.day);
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        Text(
          DateFormat('MMMM yyyy').format(_selectedDate),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, _selectedDate.day);
            });
          },
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    final List<DateTime> daysInMonth = _getDaysInMonth(_selectedDate.year, _selectedDate.month);

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: daysInMonth.length,
      itemBuilder: (context, index) {
        final day = daysInMonth[index];

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = day;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: day.month != _selectedDate.month
                ? Colors.grey
                : (DateTime.now().year == _selectedDate.year &&
                        DateTime.now().month == _selectedDate.month &&
                        DateTime.now().day == day.day
                    ? Colors.purple : Colors.green),

              border: Border.all(
                color: day.isAtSameMomentAs(DateTime.now()) ? Colors.black : Colors.transparent,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              day.day.toString(),
              style: TextStyle(
                color: day.month != _selectedDate.month ? Colors.grey : null,
                fontWeight: day.isAtSameMomentAs(DateTime.now()) ? FontWeight.bold : null,
              ),
            ),
          ),
        );
      },
    );
  }

  List<DateTime> _getDaysInMonth(int year, int month) {
    final DateTime firstDayOfMonth = DateTime(year, month, 1);
    final DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    final List<DateTime> days = [];

    // Находим первый понедельник месяца
    int firstWeekday = firstDayOfMonth.weekday;
    int offset = (firstWeekday - DateTime.monday + 7) % 7;

    for (int day = 1 - offset; day <= lastDayOfMonth.day; day++) {
      days.add(DateTime(year, month, day));
    }

    return days;
  }
}
