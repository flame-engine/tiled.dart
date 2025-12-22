import 'dart:typed_data';

import 'package:tiled/src/parser.dart';

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// `<wangtile>`
///
/// Defines a Wang tile, by referring to a tile in the tileset and associating
/// it with a certain Wang ID.
///
/// * tileid: The tile ID.
/// * wangid: The Wang ID, given by a comma-separated list of indexes
///   (starting from 1, because 0 means _unset_) referring to the Wang colors
///   in the Wang set in the following order: top, top right, right, bottom
///   right, bottom, bottom left, left, top left (since Tiled 1.5).
///   Before Tiled 1.5, the Wang ID was saved as a 32-bit unsigned integer
///   stored in the format 0xCECECECE (where each C is a corner color and
///   each E is an edge color, in reverse order).
/// * hflip: Whether the tile is flipped horizontally (removed in Tiled 1.5).
/// * vflip: Whether the tile is flipped vertically (removed in Tiled 1.5).
/// * dflip: Whether the tile is flipped on its diagonal (removed in Tiled 1.5).
class WangTile {
  int tileId;
  List<int> wangId;
  bool hFlip;
  bool vFlip;
  bool dFlip;

  WangTile({
    required this.tileId,
    required this.wangId,
    this.hFlip = false,
    this.vFlip = false,
    this.dFlip = false,
  });

  WangTile.parse(Parser parser)
      : this(
          tileId: parser.getInt('tileid'),
          wangId: parseWangIds(
            parser.formatSpecificParsing(
              (json) => json.getIntList('wangid'),
              (xml) =>
                  xml.getString('wangid').split(',').map(int.parse).toList(),
            ),
          ),
          hFlip: parser.getBool('hflip', defaults: false),
          vFlip: parser.getBool('vflip', defaults: false),
          dFlip: parser.getBool('dflip', defaults: false),
        );

  static List<int> parseWangIds(List<int> value) {
    final bytes = Uint8List.fromList(value);
    final dv = ByteData.view(bytes.buffer);
    final uint32 = <int>[];
    for (var i = 0; i < value.length; ++i) {
      if (i % 4 == 0) {
        uint32.add(dv.getUint32(i, Endian.little));
      }
    }
    return uint32;
  }
}
