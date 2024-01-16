part of tiled;

/// Interface implemented by classes that can be exported. Instead of
/// implementing [ExportResolver]'s methods on every class this mixins allows
/// for these methods to be supplied by a proxy ExportResolver.
///
/// This is the default mechanism as the xml/json structures are fairly
/// predictable.
abstract class Exportable implements ExportResolver {
  /// Returns the proxy usually an [ExportElement]
  ExportResolver export();

  @override
  XmlNode exportXml() => export().exportXml();

  @override
  JsonObject exportJson() => export().exportJson();
}
