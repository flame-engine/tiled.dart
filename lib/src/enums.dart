part of tiled;

enum MapOrientation { orthogonal, isometric, staggered, hexagonal }

extension MapOrientationExtension on MapOrientation {
  static const names = {
    MapOrientation.orthogonal: 'orthogonal',
    MapOrientation.isometric: 'isometric',
    MapOrientation.staggered: 'staggered',
    MapOrientation.hexagonal: 'hexagonal',
  };

  String get name => names[this];
}

enum RenderOrder { right_down, right_up, left_down, left_up }

extension RenderOrderExtension on RenderOrder {
  static const names = {
    RenderOrder.right_down: 'right-down',
    RenderOrder.right_up: 'right-up',
    RenderOrder.left_down: 'left-down',
    RenderOrder.left_up: 'left-up',
  };

  String get name => names[this];
}

enum StaggerAxis { x, y }

extension StaggerAxisExtension on StaggerAxis {
  static const names = {
    StaggerAxis.x: 'x',
    StaggerAxis.y: 'y',
  };

  String get name => names[this];
}

enum StaggerIndex { odd, even }

extension StaggerIndexExtension on StaggerIndex {
  static const names = {
    StaggerIndex.odd: 'odd',
    StaggerIndex.even: 'even',
  };

  String get name => names[this];
}

enum VAlign { center, bottom, top }

extension VAlignExtension on VAlign {
  static const names = {
    VAlign.center: 'center',
    VAlign.bottom: 'bottom',
    VAlign.top: 'top',
  };

  String get name => names[this];
}

enum HAlign { center, right, justify, left }

extension HAlignExtension on HAlign {
  static const names = {
    HAlign.center: 'center',
    HAlign.right: 'right',
    HAlign.justify: 'justify',
    HAlign.left: 'left',
  };

  String get name => names[this];
}

enum GridOrientation { orthogonal, isometric }

extension GridOrientationExtension on GridOrientation {
  static const names = {
    GridOrientation.orthogonal: 'orthogonal',
    GridOrientation.isometric: 'isometric',
  };

  String get name => names[this];
}

enum LayerType { tilelayer, objectlayer, imagelayer, group }

extension LayerTypeExtension on LayerType {
  static const names = {
    LayerType.tilelayer: 'tilelayer',
    LayerType.objectlayer: 'objectlayer',
    LayerType.imagelayer: 'imagelayer',
    LayerType.group: 'group',
  };

  String get name => names[this];
}

enum FileEncoding { csv, base64 }

extension FileEncodingExtension on FileEncoding {
  static const names = {
    FileEncoding.csv: 'csv',
    FileEncoding.base64: 'base64',
  };

  String get name => names[this];
}

enum DrawOrder { topdown, index_order } //Cant use "index" here

extension DrawOrderExtension on DrawOrder {
  static const names = {
    DrawOrder.topdown: 'topdown',
    DrawOrder.index_order: 'index',
  };

  String get name => names[this];
}

enum Compression { zlib, gzip, zstd }

extension CompressionExtension on Compression {
  static const names = {
    Compression.zlib: 'zlib',
    Compression.gzip: 'gzip',
    Compression.zstd: 'zstd',
  };

  String get name => names[this];
}
