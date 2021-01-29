part of tiled;

class TileMapParser {

  static TiledMap parseJson(String json) {
    if(json == null || json.isEmpty){
      throw 'Json is empty';
    }
    final TiledMap map = TiledMap.fromJson(jsonDecode(json));
    return map;
  }


  static TiledMap parseTmx(String xml, {TsxProvider tsx}) {
    if(xml == null || xml.isEmpty){
      throw 'XML is empty';
    }
    final xmlElement = XmlDocument.parse(xml).rootElement;
    if (xmlElement.name.local != 'map') {
      throw 'XML is not in TMX format';
    }
    final TiledMap map = TiledMap.fromXml(xmlElement, tsx: tsx);
    return map;
  }

}
