class Test {
  Test({
    int? count,
    String? next,
    dynamic previous,
  }) {
    _count = count;
    _next = next;
    _previous = previous;
  }

  Test.fromJson(dynamic json) {
    _count = json['count'];
    _next = json['next'];
    _previous = json['previous'];
  }

  int? _count;
  String? _next;
  dynamic _previous;

  int? get count => _count;
  String? get next => _next;
  dynamic get previous => _previous;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['next'] = _next;
    map['previous'] = _previous;
    return map;
  }
}
