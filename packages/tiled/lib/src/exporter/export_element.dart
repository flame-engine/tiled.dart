part of tiled;

abstract class ExportObject {}

abstract class ExportResolver implements ExportObject {
  XmlNode exportXml();

  JsonObject exportJson();
}

class ExportElement implements ExportResolver {
  final String name;
  final Map<String, ExportValue> fields;
  final Map<String, ExportObject> children;
  final CustomProperties? properties;

  ExportElement(
    this.name,
    this.fields,
    this.children, [
    this.properties,
  ]);

  @override
  XmlElement exportXml() {
    final _children = children.values.expand((e) {
      if (e is ExportList) {
        return e.map((e) => e.exportXml());
      } else if (e is ExportResolver) {
        return [e.exportXml()];
      } else {
        throw 'Bad State: ExportObject switch should have been exhaustive';
      }
    });

    return XmlElement(
      XmlName(name),
      fields.entries.map((e) => XmlAttribute(XmlName(e.key), e.value.xml)),
      [
        ..._children,
        if (properties != null && properties!.isNotEmpty)
          XmlElement(
            XmlName('properties'),
            [],
            properties!.map((e) => e.export().exportXml()).toList(),
          ),
      ],
    );
  }

  @override
  JsonMap exportJson() => JsonMap({
        ...fields.map(
          (key, value) => MapEntry(key, value.exportJson()),
        ),
        ...children.map((key, e) {
          if (e is ExportList) {
            return MapEntry(
              key,
              JsonList(e.map((e) => e.exportJson())),
            );
          } else if (e is ExportResolver) {
            return MapEntry(key, e.exportJson());
          } else {
            throw 'Bad State: ExportChild switch should have been exhaustive';
          }
        }),
        if (properties != null)
          'properties': JsonList(
            properties!.map((e) => e.exportJson()),
          ),
      });
}

class ExportDirect implements ExportResolver {
  final XmlElement xml;
  final JsonObject json;

  ExportDirect({required this.xml, required this.json});

  @override
  JsonObject exportJson() => json;

  @override
  XmlElement exportXml() => xml;
}

class ExportFormatSpecific implements ExportResolver {
  final ExportResolver xml;
  final ExportResolver json;

  ExportFormatSpecific({required this.xml, required this.json});

  @override
  JsonObject exportJson() => json.exportJson();

  @override
  XmlNode exportXml() => xml.exportXml();
}

class ExportList extends DelegatingList<ExportResolver> implements ExportObject {
  ExportList(Iterable<ExportResolver> base) : super(base.toList());

  ExportList.from(Iterable<Exportable> source) : super(source.map((e) => e.export()).toList());
}
