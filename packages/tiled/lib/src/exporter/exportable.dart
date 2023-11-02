part of tiled;

abstract class Exportable {
  ExportResolver export(ExportSettings settings);

  XmlNode exportXml(ExportSettings settings) => export(settings).exportXml();
  dynamic exportJson(ExportSettings settings) => export(settings).exportJson();
}
