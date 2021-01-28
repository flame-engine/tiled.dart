part of tiled;

class Template {
  Tileset tileset;
  TiledObject object;

  Template.fromXml(XmlElement xmlElement) {
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'tileset':
          tileset = Tileset.fromXml(element);
          break;
        case 'object':
          object = TiledObject.fromXml(element);
          break;
      }
    });
  }

  Template.fromJson(Map<String, dynamic> json) {
    tileset = json['tileset'] != null ? Tileset.fromJson(json['tileset']) : null;
    object = json['object'] != null ? TiledObject.fromJson(json['object']) : null;
  }
}
