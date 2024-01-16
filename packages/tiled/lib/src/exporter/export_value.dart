part of tiled;

/// Export tree leafs. Used for exporting values like strings, bools, etc.
abstract class ExportValue<T> implements ExportResolver {
  const ExportValue();

  String get xml;

  T get json;

  @override
  XmlNode exportXml() => XmlText(xml);

  @override
  JsonValue<T> exportJson() => JsonValue(json);
}

/// Literally exports the given value
class ExportLiteral<T> extends ExportValue<T> {
  final T value;

  const ExportLiteral(this.value);

  @override
  T get json => value;

  @override
  String get xml => value.toString();
}

/// Conversion to export
extension ExportableString on String {
  ExportValue toExport() => ExportLiteral<String>(this);
}

/// Conversion to export
extension ExportableNum on num {
  ExportValue toExport() => ExportLiteral<num>(this);
}

/// Encodes bool as 0 and 1
class _ExportableBool extends ExportValue<bool> {
  final bool value;

  _ExportableBool(this.value);

  @override
  bool get json => value;

  @override
  String get xml => (value ? 1 : 0).toString();
}

/// Conversion to export
extension ExportableBool on bool {
  ExportValue toExport() => _ExportableBool(this);
}

/// Encodes a list of [Point]s as a json array or space seperated xml string
class _ExportablePointList extends ExportValue<List<Map<String, double>>> {
  final List<Point> points;

  _ExportablePointList(this.points);

  @override
  List<Map<String, double>> get json => points
      .map(
        (e) => {
          'x': e.x,
          'y': e.y,
        },
      )
      .toList();

  @override
  String get xml => points.map((e) => '${e.x},${e.y}').join(' ');
}

/// Conversion to export
extension ExportablePointList on List<Point> {
  ExportValue toExport() => _ExportablePointList(this);
}
