part of tiled;

class TileMapParser {

  static TiledMap parseJson(String string) {
    // TODO Check Filetype?
    // TODO Custom parser?
    // TODO ?.toDouble()
    final TiledMap map = TiledMap.fromJson(jsonDecode(string));
    return map;
  }


  static TiledMap parseTmx(String xml, {TsxProvider tsx}) {
    // TODO Check Filetype?
    // TODO Custom parser?
    // TODO ?.toDouble()
    final xmlElement = XmlDocument.parse(xml).rootElement;
    final TiledMap map = TiledMap.fromXml(xmlElement, tsx: tsx);
    return map;
  }

}
