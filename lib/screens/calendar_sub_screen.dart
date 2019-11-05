import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSubScreen extends StatefulWidget {

  @override
  _CalendarSubScreenState createState() => _CalendarSubScreenState();

}

class _CalendarSubScreenState extends State<CalendarSubScreen> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
           _buildTableCalendarWithBuilders(),
        ],
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        selectedStyle: null,
        selectedColor: null,
        holidayStyle: null,
        weekendStyle: null,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: null,
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${date.day}',
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

//          if (events.isNotEmpty) {
//            children.add(
//              Center(
//                child: Container(
//                  decoration: BoxDecoration(
//                    shape: BoxShape.circle,
//                    border: Border.all(
//                        color: Theme.of(context).accentColor,
//                        width: 2,
//                        style: BorderStyle.solid
//                    )
//                  ),
//                  width: 36,
//                  height: 36
//                ),
//              ),
//            );
//          } else {
            children.add(
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle
                  ),
                  width: 36,
                  height: 36,
                  child: Center(
                    child: Text(
                      '${date.day}',
                    ),
                  ),
                ),
              ),
            );
//          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

}