# Tiled Dart

[![Pub](https://img.shields.io/pub/v/tiled.svg?style=popout)](https://pub.dartlang.org/packages/tiled) ![CI](https://github.com/flame-engine/tiled.dart/workflows/CI/badge.svg?branch=master&event=push) [![Discord](https://img.shields.io/discord/509714518008528896.svg)](https://discord.gg/pxrBmy4)

A Dart Tiled library.

## Install from Dart Pub Repository

Include the following in your `pubspec.yaml`:

```yaml
    dependencies:
      tiled: 0.7.0
```

## Usage

Import the package like this:

```dart
    import 'package:tiled/tiled.dart'
```

### Load Tmx Files
Load a TMX file into a string by any means, and then pass the string to TileMapParser.parseXml():

```dart
    final String tmxBody = /* ... */;
    final TiledMap mapTmx = TileMapParser.parseTmx(tmxBody);
```

If your tmx file includes a external tsx reference, you have to add a CustomParser
```dart
class CustomTsxProvider extends TsxProvider {
  @override
  XmlNode getSource(String filename) {
    final String xml = File(filename).readAsStringSync();
    return XmlDocument.parse(xml).rootElement;
  }
}
```
And use it in the parseTmx method
```dart
    final String tmxBody = /* ... */;
    final TiledMap mapTmx = TileMapParser.parseTmx(tmxBody, tsx: CustomTsxProvider());

```

### Load Json Files
Alternatively load a json file.
```dart
    final String jsonBody = /* ... */;
    final TiledMap mapTmx = TileMapParser.parseJson(jsonBody);
```

### Implementation
For further information look at the examples in flame_tiled