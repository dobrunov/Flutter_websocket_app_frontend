// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppState on AppStateBase, Store {
  late final _$mainAtom = Atom(name: 'AppStateBase.main', context: context);

  @override
  HomePage get main {
    _$mainAtom.reportRead();
    return super.main;
  }

  @override
  set main(HomePage value) {
    _$mainAtom.reportWrite(value, super.main, () {
      super.main = value;
    });
  }

  @override
  String toString() {
    return '''
main: ${main}
    ''';
  }
}
