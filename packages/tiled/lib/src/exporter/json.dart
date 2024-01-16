part of tiled;

/// Basic object in json structure, either a [JsonElement] or a [JsonValue]
abstract class JsonObject {}

/// Basic elements, eiter a [JsonList] or a [JsonMap].
/// Elements can be the root of a json file.
abstract class JsonElement implements JsonObject {}

/// List in json
class JsonList extends DelegatingList<JsonObject> implements JsonElement {
  JsonList([Iterable<JsonObject>? base]) : super(base?.toList() ?? []);

  List<JsonObject> get value => this;
}

/// Map in json
class JsonMap extends DelegatingMap<String, JsonObject> implements JsonElement {
  JsonMap([super.base = const {}]);

  Map<String, JsonObject> get value => this;
}

/// Arbitrary value that is a json type or it will be encoded using [jsonEncode]
class JsonValue<T> implements JsonObject {
  final T value;

  JsonValue(this.value);
}
