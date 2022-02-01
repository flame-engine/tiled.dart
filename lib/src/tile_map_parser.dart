part of tiled;

class TileMapParser {
  static TiledMap parseJson(String json) {
    final parser = JsonParser(jsonDecode(json) as Map<String, dynamic>);
    return TiledMap.parse(parser);
  }

  /// Parses the provided map xml.
  ///
  /// Accepts an optional list of external TsxProviders for external tilesets
  /// referenced in the map file.
  static TiledMap parseTmx(String xml, {List<TsxProvider>? tsxList}) {
    final xmlElement = XmlDocument.parse(xml).rootElement;
    if (xmlElement.name.local != 'map') {
      throw 'XML is not in TMX format';
    }
    final parser = XmlParser(xmlElement);
    return TiledMap.parse(parser, tsxList: tsxList);
  }
}
