import 'package:mobx/mobx.dart';

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

  @observable
  bool testTwo = false;

  @action
  void updateTestTwo(data) {
    testTwo = data;
  }
}
