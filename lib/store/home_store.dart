import 'package:mobx/mobx.dart';

import '../models/counter_model.dart';

part 'home_store.g.dart';

class HomePage = HomePageBase with _$HomePage;

abstract class HomePageBase with Store {
  @observable
  bool showDisconnect = false;

  @action
  void updateConnectedState(data) {
    showDisconnect = data;
  }

  @observable
  int counter = 0;

  @action
  void incrementCounter() {
    counter = counter + 1;
  }

  @action
  void updateCounter(data) {
    var counterValue = Counter.fromJson(data);
    counter = counter + counterValue.value;
  }

  @action
  void resetCounter() {
    counter = 0;
  }
}
