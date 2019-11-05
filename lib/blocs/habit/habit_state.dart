import 'package:dbtc/models/habit.dart';

abstract class HabitState {
  const HabitState();
}

class HabitsLoadingState extends HabitState {}

class HabitsLoadedState extends HabitState {
  final List<Habit> habits;
  const HabitsLoadedState(this.habits);
}

class HabitsNotLoadedState extends HabitState {}