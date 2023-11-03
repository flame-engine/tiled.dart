part of tiled;

enum MapOrientation { orthogonal, isometric, staggered, hexagonal }

extension MapOrientationExtension on MapOrientation {
  String get name {
    switch (this) {
      case MapOrientation.orthogonal:
        return 'orthogonal';
      case MapOrientation.isometric:
        return 'isometric';
      case MapOrientation.staggered:
        return 'staggered';
      case MapOrientation.hexagonal:
        return 'hexagonal';
    }
  }
}

extension MapOrientationParser on Parser {
  MapOrientation? getMapOrientationOrNull(
    String name, {
    MapOrientation? defaults,
  }) {
    return getRawEnumOrNull(
      MapOrientation.values,
      (e) => e.name,
      name,
      defaults,
    );
  }

  MapOrientation getMapOrientation(String name, {MapOrientation? defaults}) {
    return getRawEnum(MapOrientation.values, (e) => e.name, name, defaults);
  }
}

enum RenderOrder { rightDown, rightUp, leftDown, leftUp }

extension RenderOrderExtension on RenderOrder {
  String get name {
    switch (this) {
      case RenderOrder.rightDown:
        return 'right-down';
      case RenderOrder.rightUp:
        return 'right-up';
      case RenderOrder.leftDown:
        return 'left-down';
      case RenderOrder.leftUp:
        return 'left-up';
    }
  }
}

extension RenderOrderParser on Parser {
  RenderOrder? getRenderOrderOrNull(String name, {RenderOrder? defaults}) {
    return getRawEnumOrNull(RenderOrder.values, (e) => e.name, name, defaults);
  }

  RenderOrder getRenderOrder(String name, {RenderOrder? defaults}) {
    return getRawEnum(RenderOrder.values, (e) => e.name, name, defaults);
  }
}

enum StaggerAxis { x, y }

extension StaggerAxisExtension on StaggerAxis {
  String get name {
    switch (this) {
      case StaggerAxis.x:
        return 'x';
      case StaggerAxis.y:
        return 'y';
    }
  }
}

extension StaggerAxisParser on Parser {
  StaggerAxis? getStaggerAxisOrNull(String name, {StaggerAxis? defaults}) {
    return getRawEnumOrNull(StaggerAxis.values, (e) => e.name, name, defaults);
  }

  StaggerAxis getStaggerAxis(String name, {StaggerAxis? defaults}) {
    return getRawEnum(StaggerAxis.values, (e) => e.name, name, defaults);
  }
}

enum StaggerIndex { odd, even }

extension StaggerIndexExtension on StaggerIndex {
  String get name {
    switch (this) {
      case StaggerIndex.odd:
        return 'odd';
      case StaggerIndex.even:
        return 'even';
    }
  }
}

extension StaggerIndexParser on Parser {
  StaggerIndex? getStaggerIndexOrNull(String name, {StaggerIndex? defaults}) {
    return getRawEnumOrNull(StaggerIndex.values, (e) => e.name, name, defaults);
  }

  StaggerIndex getStaggerIndex(String name, {StaggerIndex? defaults}) {
    return getRawEnum(StaggerIndex.values, (e) => e.name, name, defaults);
  }
}

enum VAlign { center, bottom, top }

extension VAlignExtension on VAlign {
  String get name {
    switch (this) {
      case VAlign.center:
        return 'center';
      case VAlign.bottom:
        return 'bottom';
      case VAlign.top:
        return 'top';
    }
  }
}

extension VAlignParser on Parser {
  VAlign? getVAlignOrNull(String name, {VAlign? defaults}) {
    return getRawEnumOrNull(VAlign.values, (e) => e.name, name, defaults);
  }

  VAlign getVAlign(String name, {VAlign? defaults}) {
    return getRawEnum(VAlign.values, (e) => e.name, name, defaults);
  }
}

enum HAlign { center, right, justify, left }

extension HAlignExtension on HAlign {
  String get name {
    switch (this) {
      case HAlign.center:
        return 'center';
      case HAlign.right:
        return 'right';
      case HAlign.justify:
        return 'justify';
      case HAlign.left:
        return 'left';
    }
  }
}

extension HAlignParser on Parser {
  HAlign? getHAlignOrNull(String name, {HAlign? defaults}) {
    return getRawEnumOrNull(HAlign.values, (e) => e.name, name, defaults);
  }

  HAlign getHAlign(String name, {HAlign? defaults}) {
    return getRawEnum(HAlign.values, (e) => e.name, name, defaults);
  }
}

enum GridOrientation { orthogonal, isometric }

extension GridOrientationExtension on GridOrientation {
  String get name {
    switch (this) {
      case GridOrientation.orthogonal:
        return 'orthogonal';
      case GridOrientation.isometric:
        return 'isometric';
    }
  }
}

extension GridOrientationParser on Parser {
  GridOrientation? getGridOrientationOrNull(
    String name, {
    GridOrientation? defaults,
  }) {
    return getRawEnumOrNull(
      GridOrientation.values,
      (e) => e.name,
      name,
      defaults,
    );
  }

  GridOrientation getGridOrientation(String name, {GridOrientation? defaults}) {
    return getRawEnum(GridOrientation.values, (e) => e.name, name, defaults);
  }
}

enum LayerType { tileLayer, objectGroup, imageLayer, group }

extension LayerTypeExtension on LayerType {
  String get name {
    switch (this) {
      case LayerType.tileLayer:
        return 'tilelayer';
      case LayerType.objectGroup:
        return 'objectgroup';
      case LayerType.imageLayer:
        return 'imagelayer';
      case LayerType.group:
        return 'group';
    }
  }

  static LayerType parseFromTmx(String name) {
    if (name == 'layer') {
      return LayerType.tileLayer;
    }
    return LayerType.values.firstWhere((e) => e.name == name);
  }
}

extension LayerTypeParser on Parser {
  LayerType? getLayerTypeOrNull(String name, {LayerType? defaults}) {
    return getRawEnumOrNull(LayerType.values, (e) => e.name, name, defaults);
  }

  LayerType getLayerType(String name, {LayerType? defaults}) {
    return getRawEnum(LayerType.values, (e) => e.name, name, defaults);
  }
}

enum FileEncoding { csv, base64 }

extension FileEncodingExtension on FileEncoding {
  String get name {
    switch (this) {
      case FileEncoding.csv:
        return 'csv';
      case FileEncoding.base64:
        return 'base64';
    }
  }
}

extension FileEncodingParser on Parser {
  FileEncoding? getFileEncodingOrNull(String name, {FileEncoding? defaults}) {
    return getRawEnumOrNull(FileEncoding.values, (e) => e.name, name, defaults);
  }

  FileEncoding getFileEncoding(String name, {FileEncoding? defaults}) {
    return getRawEnum(FileEncoding.values, (e) => e.name, name, defaults);
  }
}

enum DrawOrder { topDown, indexOrder }

extension DrawOrderExtension on DrawOrder {
  String get name {
    switch (this) {
      case DrawOrder.topDown:
        return 'topdown';
      case DrawOrder.indexOrder:
        return 'index';
    }
  }
}

extension DrawOrderParser on Parser {
  DrawOrder? getDrawOrderOrNull(String name, {DrawOrder? defaults}) {
    return getRawEnumOrNull(DrawOrder.values, (e) => e.name, name, defaults);
  }

  DrawOrder getDrawOrder(String name, {DrawOrder? defaults}) {
    return getRawEnum(DrawOrder.values, (e) => e.name, name, defaults);
  }
}

enum Compression { zlib, gzip, zstd }

extension CompressionExtension on Compression {
  String get name {
    switch (this) {
      case Compression.zlib:
        return 'zlib';
      case Compression.gzip:
        return 'gzip';
      case Compression.zstd:
        return 'zstd';
    }
  }
}

extension CompressionParser on Parser {
  Compression? getCompressionOrNull(String name, {Compression? defaults}) {
    return getRawEnumOrNull(Compression.values, (e) => e.name, name, defaults);
  }

  Compression getCompression(String name, {Compression? defaults}) {
    return getRawEnum(Compression.values, (e) => e.name, name, defaults);
  }
}

enum PropertyType { string, int, float, bool, color, file, object }

extension PropertyTypeExtension on PropertyType {
  String get name {
    switch (this) {
      case PropertyType.string:
        return 'string';
      case PropertyType.int:
        return 'int';
      case PropertyType.float:
        return 'float';
      case PropertyType.bool:
        return 'bool';
      case PropertyType.color:
        return 'color';
      case PropertyType.file:
        return 'file';
      case PropertyType.object:
        return 'object';
    }
  }
}

extension PropertyTypeParser on Parser {
  PropertyType? getPropertyTypeOrNull(String name, {PropertyType? defaults}) {
    return getRawEnumOrNull(PropertyType.values, (e) => e.name, name, defaults);
  }

  PropertyType getPropertyType(String name, {PropertyType? defaults}) {
    return getRawEnum(PropertyType.values, (e) => e.name, name, defaults);
  }
}

enum TileMapType { map }

extension TileMapTypeExtension on TileMapType {
  String get name {
    switch (this) {
      case TileMapType.map:
        return 'map';
    }
  }
}

extension TileMapTypeParser on Parser {
  TileMapType? getTileMapTypeOrNull(String name, {TileMapType? defaults}) {
    return getRawEnumOrNull(TileMapType.values, (e) => e.name, name, defaults);
  }

  TileMapType getTileMapType(String name, {TileMapType? defaults}) {
    return getRawEnum(TileMapType.values, (e) => e.name, name, defaults);
  }
}

enum TilesetType { tileset }

extension TilesetTypeExtension on TilesetType {
  String get name {
    switch (this) {
      case TilesetType.tileset:
        return 'tileset';
    }
  }
}

extension TilesetTypeParser on Parser {
  TilesetType? getTilesetTypeOrNull(String name, {TilesetType? defaults}) {
    return getRawEnumOrNull(TilesetType.values, (e) => e.name, name, defaults);
  }

  TilesetType getTilesetType(String name, {TilesetType? defaults}) {
    return getRawEnum(TilesetType.values, (e) => e.name, name, defaults);
  }
}

enum ObjectAlignment {
  unspecified,
  topLeft,
  top,
  topRight,
  left,
  center,
  right,
  bottomLeft,
  bottom,
  bottomRight,
}

extension ObjectAlignmentExtension on ObjectAlignment {
  String get name {
    switch (this) {
      case ObjectAlignment.unspecified:
        return 'unspecified';
      case ObjectAlignment.topLeft:
        return 'topleft';
      case ObjectAlignment.top:
        return 'top';
      case ObjectAlignment.topRight:
        return 'topright';
      case ObjectAlignment.left:
        return 'left';
      case ObjectAlignment.center:
        return 'center';
      case ObjectAlignment.right:
        return 'right';
      case ObjectAlignment.bottomLeft:
        return 'bottomleft';
      case ObjectAlignment.bottom:
        return 'bottom';
      case ObjectAlignment.bottomRight:
        return 'bottomright';
    }
  }
}

extension ObjectAlignmentParser on Parser {
  ObjectAlignment? getObjectAlignmentOrNull(
    String name, {
    ObjectAlignment? defaults,
  }) {
    return getRawEnumOrNull(
      ObjectAlignment.values,
      (e) => e.name,
      name,
      defaults,
    );
  }

  ObjectAlignment getObjectAlignment(String name, {ObjectAlignment? defaults}) {
    return getRawEnum(ObjectAlignment.values, (e) => e.name, name, defaults);
  }
}
