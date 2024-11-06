class Counter {
  final int value;

  Counter({
    this.value = 0,
  });

  factory Counter.fromJson(Map<String, dynamic> jsonMap) {
    return Counter(value: jsonMap['value']);
  }
}
