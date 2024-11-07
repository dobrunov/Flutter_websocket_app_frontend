// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomePage on HomePageBase, Store {
  late final _$showDisconnectAtom =
      Atom(name: 'HomePageBase.showDisconnect', context: context);

  @override
  bool get showDisconnect {
    _$showDisconnectAtom.reportRead();
    return super.showDisconnect;
  }

  @override
  set showDisconnect(bool value) {
    _$showDisconnectAtom.reportWrite(value, super.showDisconnect, () {
      super.showDisconnect = value;
    });
  }

  late final _$counterAtom =
      Atom(name: 'HomePageBase.counter', context: context);

  @override
  int get counter {
    _$counterAtom.reportRead();
    return super.counter;
  }

  @override
  set counter(int value) {
    _$counterAtom.reportWrite(value, super.counter, () {
      super.counter = value;
    });
  }

  late final _$HomePageBaseActionController =
      ActionController(name: 'HomePageBase', context: context);

  @override
  void updateConnectedState(dynamic data) {
    final _$actionInfo = _$HomePageBaseActionController.startAction(
        name: 'HomePageBase.updateConnectedState');
    try {
      return super.updateConnectedState(data);
    } finally {
      _$HomePageBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void incrementCounter() {
    final _$actionInfo = _$HomePageBaseActionController.startAction(
        name: 'HomePageBase.incrementCounter');
    try {
      return super.incrementCounter();
    } finally {
      _$HomePageBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCounter(dynamic data) {
    final _$actionInfo = _$HomePageBaseActionController.startAction(
        name: 'HomePageBase.updateCounter');
    try {
      return super.updateCounter(data);
    } finally {
      _$HomePageBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetCounter() {
    final _$actionInfo = _$HomePageBaseActionController.startAction(
        name: 'HomePageBase.resetCounter');
    try {
      return super.resetCounter();
    } finally {
      _$HomePageBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showDisconnect: ${showDisconnect},
counter: ${counter}
    ''';
  }
}
