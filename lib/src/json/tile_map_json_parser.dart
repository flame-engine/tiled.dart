part of tiled;

class TileMapJsonParser {
  TileMapJsonParser();

  MapJson parse(String string) {
    // TODO Check Filetype?
    // TODO Custom parser?
    // TODO ?.toDouble()
    final MapJson mapJson = MapJson.fromJson(jsonDecode(string));
    return mapJson;
  }
}
