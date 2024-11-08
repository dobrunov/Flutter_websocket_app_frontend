import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/counter_model.dart';

class CounterState {
  final int counter;

  CounterState({this.counter = 0});

  CounterState copyWith({int? counter}) {
    return CounterState(
      counter: counter ?? this.counter,
    );
  }
}

class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier() : super(CounterState());

  void incrementCounter() {
    state = state.copyWith(counter: state.counter + 1);
  }

  void updateCounter(data) {
    var counter = Counter.fromJson(data);
    state = state.copyWith(counter: state.counter + counter.value);
  }
}

final counterProvider = StateNotifierProvider<CounterNotifier, CounterState>((ref) => CounterNotifier());
