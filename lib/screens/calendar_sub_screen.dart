import 'package:dbtc/blocs/habit/habit.dart';
import 'package:dbtc/models/habit.dart';
import 'package:dbtc/screens/habit_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSubScreen extends StatefulWidget {

  @override
  _CalendarSubScreenState createState() => _CalendarSubScreenState();

}

class _CalendarSubScreenState extends State<CalendarSubScreen> with TickerProviderStateMixin {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime date, List<Habit> habits) {
    List<Habit> habitsForDay = habits.where((habit) => habit.createdAt.isBefore(date)).toList();
    if (habitsForDay.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HabitListScreen(date, habitsForDay)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: _buildWithHabit,
    );
  }

  Widget _buildWithHabit(BuildContext context, HabitState state) {
    if (state is HabitsLoadedState) {
      return Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTableCalendar(state.habits),
          ],
        ),
      );
    } else {
      return Text('Loading');
    }
  }

  Widget _buildTableCalendar(List<Habit> habits) {
    return TableCalendar(
      calendarController: _calendarController,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
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
        dayBuilder: (context, date, events) => _buildDay(date, habits),
        todayDayBuilder: (context, date, events) {
          return Container(
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              shape: BoxShape.circle,
            ),
            child: _buildDay(date, habits)
          );
        }
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, habits);
      },
    );
  }

  Widget _buildDay(DateTime date, List<Habit> habits) {
    return Center(
      child: Container(
        decoration: _buildBoxDecoration(date, habits),
        width: 36,
        height: 36,
        child: Center(
          child: Text(
            '${date.day}',
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(DateTime date, List<Habit> habits) {
    List<bool> completions = habits
        .where((habit) => habit.createdAt.isBefore(date))
        .map((habit) {
          String dateKey = DateFormat('yyyy-MM-dd').format(date);
          return habit.completedAtDate[dateKey] != null && habit.completedAtDate[dateKey];
        }).toList();

    bool isIncomplete = completions.isEmpty || completions.every((completion) => !completion);
    bool isComplete = completions.isNotEmpty && completions.every((completion) => completion);
    bool isPartial = !isComplete && !isIncomplete;

    if (isPartial) {
      return BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Theme.of(context).accentColor,
              width: 4,
              style: BorderStyle.solid
          )
      );
    } else if (isComplete) {
      return BoxDecoration(
          color: Theme.of(context).accentColor,
          shape: BoxShape.circle
      );
    } else {
      return null;
    }
  }

}