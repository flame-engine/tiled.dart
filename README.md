# Tiled Dart

A Dart Tiled library.

## Install from Dart Pub Repository

Include the following in your `pubspec.yaml`:

    dependencies:
      tiled: any

## Usage

Import the package like this:

    import 'package:tiled/tiled.dart'

Load a TMX file into a string by any means, and then pass the string to an instance of TileMapParser.parse:

    string tmxBody = /* ... */;
    var parser = new TileMapParser();
    TileMap map = parser.parse(tmxBody);

## Credits

TMX support is work of @radicaled and we have got his code from [tmx.dart lib](https://github.com/radicaled/tmx.dart)