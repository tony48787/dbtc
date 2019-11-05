import 'package:dbtc/models/habit.dart';

abstract class HabitState {
  const HabitState();
}

class HabitsLoadingState extends HabitState {}

class HabitsLoadedState extends HabitState {
  final List<Habit> habits;

  const HabitsLoadedState([this.habits = const []]);

  @override
  String toString() => 'HabitsLoaded { habits: $habits }';
}

class HabitsNotLoadedState extends HabitState {}