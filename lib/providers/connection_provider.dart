import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionState {
  final bool isConnected;

  ConnectionState({this.isConnected = true});

  ConnectionState copyWith({bool? isConnected}) {
    return ConnectionState(
      isConnected: isConnected ?? this.isConnected,
    );
  }

  bool get showDisconnect => !isConnected;
}

class ConnectionNotifier extends StateNotifier<ConnectionState> {
  ConnectionNotifier() : super(ConnectionState());

  void updateConnectedState(bool isConnected) {
    state = state.copyWith(isConnected: isConnected);
  }
}

final connectionProvider = StateNotifierProvider<ConnectionNotifier, ConnectionState>((ref) => ConnectionNotifier());
