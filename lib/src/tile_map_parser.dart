part of tiled;

class TileMapParser {
  static TiledMap parseJson(String json) {
    final parser = JsonParser(jsonDecode(json) as Map<String, dynamic>);
    return TiledMap.parse(parser);
  }

  static TiledMap parseTmx(String xml, {List<TsxProvider>? tsxList}) {
    final xmlElement = XmlDocument.parse(xml).rootElement;
    if (xmlElement.name.local != 'map') {
      throw 'XML is not in TMX format';
    }
    final parser = XmlParser(xmlElement);
    return TiledMap.parse(parser, tsxList: tsxList);
  }
}
