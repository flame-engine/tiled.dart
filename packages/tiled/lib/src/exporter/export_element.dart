part of tiled;

/// Base type for all other types. This is necessary to allow for Lists
abstract class ExportObject {}

/// Base type for everything that returns a single exported value
abstract class ExportResolver implements ExportObject {
  /// Creates an XmlNode representing the value
  XmlNode exportXml();

  /// Creates an JsonObject representing this value
  JsonObject exportJson();
}

/// Element/object for exporting with default structure
class ExportElement implements ExportResolver {
  final String name;
  final Map<String, ExportValue> fields;
  final Map<String, ExportObject> children;
  final CustomProperties? properties;

  const ExportElement(
    this.name,
    this.fields,
    this.children, [
    this.properties,
  ]);

  @override
  XmlElement exportXml() => XmlElement(
        XmlName(name),
        fields.entries.map((e) => XmlAttribute(XmlName(e.key), e.value.xml)),
        [
          ...children.values.expand((e) {
            if (e is ExportList) {
              return e.map((e) => e.exportXml());
            }

            if (e is ExportResolver) {
              return [e.exportXml()];
            }

            throw 'Bad State: ExportObject switch should have been exhaustive';
          }),
          if (properties != null && properties!.isNotEmpty)
            XmlElement(
              XmlName('properties'),
              [],
              properties!.map((e) => e.exportXml()).toList(),
            ),
        ],
      );

  @override
  JsonMap exportJson() => JsonMap({
        ...fields.map((key, value) => MapEntry(key, value.exportJson())),
        ...children.map((key, e) {
          if (e is ExportList) {
            return MapEntry(key, JsonList(e.map((e) => e.exportJson())));
          }

          if (e is ExportResolver) {
            return MapEntry(key, e.exportJson());
          }

          throw 'Bad State: ExportChild switch should have been exhaustive';
        }),
        if (properties != null)
          'properties': JsonList(
            properties!.map((e) => e.exportJson()),
          ),
      });
}

/// Splits export tree according to the type of export using an ExportResolver
/// for each.
class ExportFormatSpecific implements ExportResolver {
  final ExportResolver xml;
  final ExportResolver json;

  const ExportFormatSpecific({required this.xml, required this.json});

  @override
  JsonObject exportJson() => json.exportJson();

  @override
  XmlNode exportXml() => xml.exportXml();
}

/// List of ExportResolvers. This is used to get Lists into json, while simply
/// expanding in xml
class ExportList extends DelegatingList<ExportResolver>
    implements ExportObject {
  ExportList(Iterable<ExportResolver> base) : super(base.toList());

  ExportList.from(Iterable<Exportable> source)
      : super(
          source.map((e) => e).toList(),
        );
}
