# Tiled Dart

[![Pub](https://img.shields.io/pub/v/tiled.svg?style=popout)](https://pub.dartlang.org/packages/tiled) ![CI](https://github.com/flame-engine/tiled.dart/workflows/CI/badge.svg?branch=master&event=push) [![Discord](https://img.shields.io/discord/509714518008528896.svg)](https://discord.gg/pxrBmy4)

A Dart Tiled library.

## Install from Dart Pub Repository

Include the following in your `pubspec.yaml`:

```yaml
    dependencies:
      tiled: 0.3.0
```

## Usage

Import the package like this:

```dart
    import 'package:tiled/tiled.dart'
```

Load a TMX file into a string by any means, and then pass the string to an instance of TileMapParser.parse:

```dart
    final String tmxBody = /* ... */;
    final TileMapParser parser = TileMapParser();
    final TileMap map = parser.parse(tmxBody);
```

## Credits

TMX support is work of @radicaled and we have got his code from [tmx.dart](https://github.com/radicaled/tmx.dart) lib.
