part of tiled;

/// <template>
/// The template root element contains the saved map object and a tileset
/// element that points to an external tileset, if the object is a tile object.
///
/// Example of a template file:
///
/// ```
///   <?xml version="1.0" encoding="UTF-8"?>
///   <template>
///    <tileset firstgid="1" source="desert.tsx"/>
///    <object name="cactus" gid="31" width="81" height="101"/>
///   </template>
/// ```
///
/// Can contain at most one: <tileset>, <object>
class Template {
  Tileset? tileSet;
  TiledObject? object;

  Template({
    this.tileSet,
    this.object,
  });

  static Template parse(Parser parser) {
    return Template(
      tileSet: parser.getSingleChildOrNullAs('tileset', Tileset.parse),
      object: parser.getSingleChildOrNullAs('object', TiledObject.parse),
    );
  }
}
