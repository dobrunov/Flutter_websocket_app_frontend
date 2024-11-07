import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/counter_model.dart';

class CounterState {
  final int counter;
  final bool showDisconnect;

  CounterState({this.counter = 0, this.showDisconnect = false});

  CounterState copyWith({int? counter, bool? showDisconnect}) {
    return CounterState(
      counter: counter ?? this.counter,
      showDisconnect: showDisconnect ?? this.showDisconnect,
    );
  }
}

class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier() : super(CounterState());

  void incrementCounter() {
    state = state.copyWith(counter: state.counter + 1);
  }

  void updateConnectedState(bool isConnected) {
    state = state.copyWith(showDisconnect: !isConnected);
  }

  void updateCounter(data) {
    var counter = Counter.fromJson(data);
    state = state.copyWith(counter: state.counter + counter.value);
  }
}

final counterProvider = StateNotifierProvider<CounterNotifier, CounterState>((ref) => CounterNotifier());
