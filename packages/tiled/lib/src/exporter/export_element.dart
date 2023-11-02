part of tiled;

abstract class ExportObject {}

abstract class ExportResolver implements ExportObject {
  XmlNode exportXml();

  dynamic exportJson();
}

class ExportElement implements ExportResolver {
  final String name;
  final Map<String, ExportValue> fields;
  final Map<String, ExportObject> children;
  final CustomProperties properties;

  ExportElement(
    this.name,
    this.fields,
    this.children, [
    this.properties = CustomProperties.empty,
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
        if (properties.isNotEmpty)
          XmlElement(
            XmlName('properties'),
            [],
            properties.map((e) => e.export().exportXml()).toList(),
          ),
      ],
    );
  }

  @override
  Map<String, dynamic> exportJson() => <String, dynamic>{
        ...fields.map<String, dynamic>(
          (key, value) => MapEntry<String, dynamic>(key, value.json),
        ),
        ...children.map<String, dynamic>((key, e) {
          if (e is ExportList) {
            return MapEntry<String, Iterable<dynamic>>(
              key,
              e.map<dynamic>((e) => e.exportJson()).toList(),
            );
          } else if (e is ExportResolver) {
            return MapEntry<String, dynamic>(key, e.exportJson());
          } else {
            throw 'Bad State: ExportChild switch should have been exhaustive';
          }
        }),
        'properties': properties.map((e) => e.export().exportJson()).toList(),
      };
}

class ExportDirect implements ExportResolver {
  final XmlElement xml;
  final dynamic json;

  ExportDirect({required this.xml, required this.json});

  @override
  dynamic exportJson() => json;

  @override
  XmlElement exportXml() => xml;
}

class ExportFormatSpecific implements ExportResolver {
  final ExportResolver xml;
  final ExportResolver json;

  ExportFormatSpecific({required this.xml, required this.json});

  @override
  dynamic exportJson() => json.exportJson();

  @override
  XmlNode exportXml() => xml.exportXml();
}

class ExportList extends DelegatingList<ExportResolver>
    implements ExportObject {
  ExportList(Iterable<ExportResolver> base) : super(base.toList());

  ExportList.from(Iterable<Exportable> source, ExportSettings settings)
      : super(source.map((e) => e.export(settings)).toList());
}
