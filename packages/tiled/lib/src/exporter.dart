part of tiled;

abstract class Exporter<T> {
  T exportValue(Exportable value);

  T exportElement(String name, Map<String, Exportable> attributes, Map<String, Iterable<T>> children);

  E formatSpecificExporting<E>(
    E Function(XmlExporter) xml,
    E Function(JsonExporter) json,
  );
}

class XmlExporter extends Exporter<XmlNode> {
  @override
  XmlNode exportValue(Exportable value) => XmlText(value.xml());

  @override
  XmlNode exportElement(
    String name,
    Map<String, Exportable> attributes,
    Map<String, Iterable<XmlNode>> children,
  ) {
    final element = XmlElement(
      XmlName(name),
      attributes.entries.map(
        (e) => XmlAttribute(
          XmlName(e.key),
          e.value.xml(),
        ),
      ),
      children.values.flattened,
    );

    return element;
  }

  @override
  E formatSpecificExporting<E>(
    E Function(XmlExporter p1) xml,
    E Function(JsonExporter p1) json,
  ) {
    return xml(this);
  }
}

class JsonExporter extends Exporter<dynamic> {
  @override
  dynamic exportValue(dynamic value) => value;

  @override
  Map<String, dynamic> exportElement(
    String name,
    Map<String, Exportable> attributes,
    Map<String, Iterable<dynamic>> children,
  ) =>
      <String, dynamic>{
        ...attributes,
        ...children,
      };

  @override
  E formatSpecificExporting<E>(
    E Function(XmlExporter p1) xml,
    E Function(JsonExporter p1) json,
  ) {
    return json(this);
  }
}

extension DataExport on List<int> {

}
