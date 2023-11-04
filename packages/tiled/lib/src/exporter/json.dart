part of tiled;

abstract class JsonObject {
  dynamic get value;
}

class JsonList extends DelegatingList<JsonObject> implements JsonObject {
  JsonList([Iterable<JsonObject>? base]) : super(base?.toList() ?? []);

  @override
  List<JsonObject> get value => this;
}

class JsonMap extends DelegatingMap<String, JsonObject> implements JsonObject {
  JsonMap([super.base = const {}]);

  @override
  Map<String, JsonObject> get value => this;
}

class JsonValue<T> implements JsonObject {
  @override
  final T value;

  JsonValue(this.value);
}
