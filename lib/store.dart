import 'package:mobx/mobx.dart';

import 'home_store.dart';

// Include generated file
// flutter packages pub run build_runner build --delete-conflicting-outputs
part 'store.g.dart';

class AppState = AppStateBase with _$AppState;

abstract class AppStateBase with Store {
  @observable
  HomePage main = HomePage();
}
