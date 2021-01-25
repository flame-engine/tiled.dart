part of tiled;

class TileMapJsonParser {
  TileMapJsonParser();

  MapJson parse(String string) {
    // TODO Check Filetype?
    // TODO Custom parser?
    // TODO ?.toDouble()
    final MapJson mapJson = MapJson.fromJson(jsonDecode(string));
    return mapJson;
  }


  MapJson parseXml(String xml) {
    // TODO Check Filetype?
    // TODO Custom parser?
    // TODO ?.toDouble()
    final xmlElement = XmlDocument.parse(xml).rootElement;
    final MapJson mapJson = MapJson.fromXml(xmlElement);
    return mapJson;
  }

}
