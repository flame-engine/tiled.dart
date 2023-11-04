part of tiled;

abstract class Exportable {
  ExportResolver export();

  XmlNode exportXml() => export().exportXml();
  JsonObject exportJson() => export().exportJson();
}
