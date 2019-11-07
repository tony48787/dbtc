import 'package:dbtc/models/habit.dart';

abstract class HabitEvent {}

// ACTIONS
class LoadHabits extends HabitEvent {
  final String userId;
  LoadHabits(this.userId);
}

class AddHabit extends HabitEvent {
  final String userId;
  final Habit habit;

  AddHabit(this.userId, this.habit);

  @override
  String toString() => 'AddHabit { habit: $habit }';
}

class UpdateHabit extends HabitEvent {
  final String userId;
  final Habit updatedHabit;

  UpdateHabit(this.userId, this.updatedHabit);

  @override
  String toString() => 'UpdateHabit { updatedHabit: $updatedHabit }';
}

class DeleteHabit extends HabitEvent {
  final String userId;
  final String habitId;
  DeleteHabit(this.userId, this.habitId);
}

// EVENTS
class HabitsUpdated extends HabitEvent {
  final List<Habit> habits;

  HabitsUpdated(this.habits);
}