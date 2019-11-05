import 'package:dbtc/models/habit.dart';

abstract class HabitEvent {}

class LoadHabits extends HabitEvent {}

class AddHabit extends HabitEvent {
  final Habit habit;

  AddHabit(this.habit);

  @override
  String toString() => 'AddHabit { habit: $habit }';
}

class UpdateHabit extends HabitEvent {
  final Habit updatedHabit;

  UpdateHabit(this.updatedHabit);

  @override
  String toString() => 'UpdateHabit { updatedHabit: $updatedHabit }';
}

class HabitsUpdated extends HabitEvent {
  final List<Habit> habits;

  HabitsUpdated(this.habits);
}