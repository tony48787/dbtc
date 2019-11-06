import 'package:dbtc/models/habit.dart';

abstract class HabitEvent {}

// ACTIONS
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

class DeleteHabit extends HabitEvent {
  final String habitId;
  DeleteHabit(this.habitId);
}

// EVENTS
class HabitsUpdated extends HabitEvent {
  final List<Habit> habits;

  HabitsUpdated(this.habits);
}