part of tiled;

abstract class ExportValue<T> implements ExportObject, ExportResolver {
  const ExportValue();

  String get xml;
  T get json;

  @override
  XmlNode exportXml() => XmlText(xml);

  @override
  JsonValue<T> exportJson() => JsonValue(json);
}

class ExportLiteral<T> extends ExportValue<T> {
  final T value;

  const ExportLiteral(this.value);

  @override
  T get json => value;

  @override
  String get xml => value.toString();
}

extension ExportableString on String {
  ExportValue toExport() => ExportLiteral<String>(this);
}

extension ExportableNum on num {
  ExportValue toExport() => ExportLiteral<num>(this);
}

class _ExportableBool extends ExportValue<bool> {
  final bool value;

  _ExportableBool(this.value);

  @override
  bool get json => value;

  @override
  String get xml => (value ? 1 : 0).toString();
}

extension ExportableBool on bool {
  ExportValue toExport() => _ExportableBool(this);
}

class _ExportablePointList extends ExportValue<List<Map<String, double>>> {
  final List<Point> points;

  _ExportablePointList(this.points);

  @override
  List<Map<String, double>> get json => points.map((e) => {
        'x': e.x,
        'y': e.y,
      }).toList();

  @override
  String get xml => points.map((e) => '${e.x},${e.y}').join(' ');
}

extension ExportablePointList on List<Point> {
  ExportValue toExport() => _ExportablePointList(this);
}
