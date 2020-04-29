part of tiled;

class Layer {
  static const int FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
  static const int FLIPPED_VERTICALLY_FLAG = 0x40000000;
  static const int FLIPPED_DIAGONALLY_FLAG = 0x20000000;

  String name;
  int width;
  int height;
  bool visible;

  TileMap map;
  List<List<int>> tileMatrix;
  List<List<int>> tileRotation;

  List<List<Tile>> _tiles;
  List<List<Tile>> get tiles {
    if (_tiles == null) {
      _recalculateTiles();
    }
    return _tiles;
  }

  Layer(this.name, this.width, this.height);

  Layer.fromXML(XmlElement element) {
    if (element == null) {
      throw 'arg "element" cannot be null';
    }

    NodeDSL.on(element, (dsl) {
      name = dsl.strOr('name', name);
      width = dsl.intOr('width', width);
      height = dsl.intOr('height', height);
      visible = dsl.boolOr('visible', true);
    });

    var dataElement = element.children.firstWhere(
        (node) => node is XmlElement && node.name.local == 'data',
        orElse: () => null);
    if (dataElement is XmlElement) {
      var decoder =
          TileMapParser._getDecoder(dataElement.getAttribute('encoding'));
      var decompressor = TileMapParser._getDecompressor(
          dataElement.getAttribute('compression'));

      var decodedString = decoder(dataElement.text);
      var inflatedString = decompressor?.call(decodedString) ?? decodedString;

      assembleTileMatrix(inflatedString);
    }
  }

  // TMX data format documented here: https://github.com/bjorn/tiled/wiki/TMX-Map-Format#data
  assembleTileMatrix(var bytes) {
    tileMatrix = new List<List<int>>(height);
    tileRotation = new List<List<int>>(height);

    var tileIndex = 0;
    for (var y = 0; y < height; ++y) {
      tileMatrix[y] = new List<int>(width);
      tileRotation[y] = new List<int>(width);
      for (var x = 0; x < width; ++x) {
        var globalTileId = bytes[tileIndex] |
            bytes[tileIndex + 1] << 8 |
            bytes[tileIndex + 2] << 16 |
            bytes[tileIndex + 3] << 24;

        tileIndex += 4;

        // Read out the flags
        bool flippedHorizontally = (globalTileId & FLIPPED_HORIZONTALLY_FLAG) == FLIPPED_HORIZONTALLY_FLAG;
        bool flippedVertically = (globalTileId & FLIPPED_VERTICALLY_FLAG) == FLIPPED_VERTICALLY_FLAG;
        bool flippedDiagonally = (globalTileId & FLIPPED_DIAGONALLY_FLAG) == FLIPPED_DIAGONALLY_FLAG;

        //Translating the flags into rotation
        if(
          !flippedHorizontally && 
          flippedVertically && 
          flippedDiagonally){
            tileRotation[y][x] = 1; //90 °
        }else if(
          flippedHorizontally && 
          flippedVertically && 
          !flippedDiagonally){
            tileRotation[y][x] = 2; //180 °
        }else if(
          flippedHorizontally && 
          !flippedVertically && 
          flippedDiagonally){
            tileRotation[y][x] = 3; //270 °
        }else if(
          !flippedHorizontally && 
          flippedVertically && 
          !flippedDiagonally){
            tileRotation[y][x] = 4; //0° + Vertical flip
        }else if(
          flippedHorizontally && 
          flippedVertically && 
          flippedDiagonally){
            tileRotation[y][x] = 5; //90° + Vertical flip
        }else if(
          flippedHorizontally && 
          !flippedVertically && 
          !flippedDiagonally){
            tileRotation[y][x] = 6; //0° + Horizontal flip
        }else if(
          !flippedHorizontally && 
          !flippedVertically && 
          flippedDiagonally){
            tileRotation[y][x] = 7; //90° + Horizontal flip
        }else{
          tileRotation[y][x] = 0; //No rotation
          /*
            !flippedHorizontally && 
            !flippedVertically && 
            !flippedDiagonally
          */
        }

        // Clear the flags

        globalTileId &= ~(FLIPPED_HORIZONTALLY_FLAG |
            FLIPPED_VERTICALLY_FLAG |
            FLIPPED_DIAGONALLY_FLAG);

        tileMatrix[y][x] = globalTileId;
      }
    }
  }

  _recalculateTiles() {
    var px = 0;
    var py = 0;
    var rotation;
    var tileId;
    var tile;
    _tiles = new List<List<Tile>>(width);
   
    _tiles.asMap().forEach( (i,e){
      _tiles[i] = new List(height);
    } );

    _tiles.asMap().forEach((i, List<Tile> cols) {
      px = 0;
      
      cols.asMap().forEach((j, Tile t) {
        tileId = tileMatrix[i][j];
        rotation = tileRotation[i][j];
        tile = map.getTileByGID(tileId)
        ..x = j
        ..y = i
        ..px = px
        ..py = py
        ..rotation = rotation;
      
        _tiles[i][j] = tile;
        px += map.tileWidth;
      });
    
      py += map.tileHeight;
    });
  }
}
