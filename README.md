#tmx.dart

tmx.dart parses [TMX files](https://github.com/bjorn/tiled/wiki/TMX-Map-Format) produced by the [Tiled map editor](http://www.mapeditor.org/).

tmx.dart works on both the client and server (dartvm) platforms.

##Install from Dart Pub Repository

Include the following in your `pubspec.yaml`:

    dependencies:
      tmx: any

Then run the [Pub Package Manager](http://pub.dartlang.org/doc) in Dart Editor (Tool > Pub Install). If you are using a different editor, run the command
(comes with the Dart SDK):

    pub install

##Usage

Load a TMX file into a string by any means, and then pass the string to an instance of TileMapParser.parse:

    string tmxBody = /* ... */;
    var parser = new TileMapParser();
    TileMap map = parser.parse(tmxBody);

##Important Notes

* Only zlib compression is supported for now.
* The API grew out of another codebase, so if anything looks screwy / strange, drop us a line using Github Issues.
