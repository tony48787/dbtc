import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dbtc/blocs/habit/habit.dart';
import 'package:dbtc/repository/habit_repository.dart';
import 'package:flutter/foundation.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitRepository _habitRepository;
  StreamSubscription _habitsSubscription;

  HabitBloc({@required HabitRepository habitRepository})
    : assert (habitRepository != null),
        _habitRepository = habitRepository;

  @override
  HabitState get initialState => HabitsLoadingState();

  @override
  Stream<HabitState> mapEventToState(HabitEvent event) async* {
    if (event is LoadHabits) {
      yield* _mapLoadHabitsToState();
    } else if (event is HabitsUpdated) {
      yield* _mapHabitsUpdatedToState(event);
    } else if (event is UpdateHabit) {
      yield* _mapUpdateHabitToState(event);
    } else if (event is AddHabit) {
      yield* _mapAddHabitToState(event);
    }
  }

  Stream<HabitState> _mapLoadHabitsToState() async* {
    _habitsSubscription?.cancel();
    _habitsSubscription = _habitRepository.habits().listen(
        (habits) => add(HabitsUpdated(habits))
    );
  }

  Stream<HabitState> _mapHabitsUpdatedToState(HabitsUpdated event) async* {
    yield HabitsLoadedState(event.habits);
  }

  Stream<HabitState> _mapUpdateHabitToState(UpdateHabit event) async* {
    _habitRepository.updateHabit(event.updatedHabit);
  }

  Stream<HabitState> _mapAddHabitToState(AddHabit event) async* {
    _habitRepository.addNewHabit(event.habit);
  }


  @override
  void close() {
    _habitsSubscription?.cancel();
    super.close();
  }
}