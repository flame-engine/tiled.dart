part of tiled;

abstract class JsonObject {
  dynamic get value;
}

class JsonList extends DelegatingList<JsonObject> implements JsonObject {
  JsonList([super.base = const []]);

  @override
  List<JsonObject> get value => this;
}

class JsonMap extends DelegatingMap<String, JsonObject> implements JsonObject {
  JsonMap([super.base = const {}]);

  @override
  Map<String, JsonObject> get value => this;
}

class JsonValue implements JsonObject {
  @override
  dynamic get value => this;
}
