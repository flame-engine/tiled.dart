part of tmx;

class Tileset {
  int gid;
  int width;
  int height;
  String name;

  TileMap map;

  List<Image> images = new List<Image>();
  Map<String, String> properties = new Map<String, String>();
  Tileset(this.gid);
}