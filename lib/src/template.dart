part of tiled;

class Template {
  TileSet tileSet;
  TiledObject object;

  Template.fromXml(XmlElement xmlElement) {
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'tileset':
          tileSet = TileSet.fromXml(element, tsx: null); // TODO is it possible to have an externel tsx here?
          break;
        case 'object':
          object = TiledObject.fromXml(element);
          break;
      }
    });
  }

  Template.fromJson(Map<String, dynamic> json) {
    tileSet = json['tileset'] != null ? TileSet.fromJson(json['tileset']) : null;
    object = json['object'] != null ? TiledObject.fromJson(json['object']) : null;
  }
}
