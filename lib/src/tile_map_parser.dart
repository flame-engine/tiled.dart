part of tiled;

class TileMapParser {
  static TiledMap parseJson(String json) {
    final parser = JsonParser(jsonDecode(json));
    return TiledMap.parse(parser);
  }

  static TiledMap parseTmx(String xml, {TsxProvider? tsx}) {
    final xmlElement = XmlDocument.parse(xml).rootElement;
    if (xmlElement.name.local != 'map') {
      throw 'XML is not in TMX format';
    }
    final parser = XmlParser(xmlElement);
    return TiledMap.parse(parser, tsx: tsx);
  }
}
