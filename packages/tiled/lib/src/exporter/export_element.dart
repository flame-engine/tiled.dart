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
      switch (e.runtimeType) {
        case ExportList:
          return (e as ExportList).map((e) => e.exportXml());
        case ExportResolver:
          return [(e as ExportResolver).exportXml()];
        case ExportValue:
          return [XmlText((e as ExportValue).xml)];
        default:
          throw 'Bad State: ExportChild switch should have been exhaustive';
      }
    });

    return XmlElement(
      XmlName(name),
      fields.entries.map((e) => XmlAttribute(XmlName(e.key), e.value.xml)),
      [
        ..._children,
        XmlElement(
          XmlName('properties'),
          [],
          properties.map((e) => e.export().exportXml()),
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
          switch (e.runtimeType) {
            case ExportList:
              return MapEntry<String, Iterable<dynamic>>(
                key,
                (e as ExportList).map<dynamic>((e) => e.exportJson()),
              );
            case ExportResolver:
              return MapEntry<String, dynamic>(
                key,
                (e as ExportElement).exportJson(),
              );
            default:
              throw 'Bad State: ExportChild switch should have been exhaustive';
          }
        }),
        'properties': properties.map((e) => e.export().exportJson()),
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
