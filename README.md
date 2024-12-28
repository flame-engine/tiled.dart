# Tiled Dart

[![Pub](https://img.shields.io/pub/v/tiled.svg?style=popout)](https://pub.dartlang.org/packages/tiled) ![cicd](https://github.com/flame-engine/tiled.dart/workflows/cicd/badge.svg?branch=main&event=push) [![Discord](https://img.shields.io/discord/509714518008528896.svg)](https://discord.gg/pxrBmy4)

A Dart Tiled library.

## Install from Dart Pub Repository

To include the package as a depencency in your `pubspec.yaml`, run the following (or add it manually):

```sh
dart pub add tiled
```

## Usage

Import the package like this:

```dart
    import 'package:tiled/tiled.dart';
```

### Load Tmx Files

Load a TMX file into a string by any means, and then pass the string to TileMapParser.parseXml():

```dart
    final String tmxBody = /* ... */;
    final TiledMap mapTmx = TiledMap.parseTmx(tmxBody);
```

If your tmx file includes external reference, e.g. for .tsx files, you have to add providers.
These providers are then used to find these files and load their contents as a string, 
as well as maybe caching them.

To construct a provider for tsx files for example you can just extend the Provider<Parser>
or ParserProvider class, which is just a type alias.
```dart
class MultipleTsxProvider extends ParserProvider {
  @override
  bool canProvide(String filename) => ["external1.tsx", "external2.tsx"].contains(filename);
  
  @override
  Parser? getCachedSource(String filename) => null;
  
  @override
  Parser getSource(String fileName) {
    final xml = File(fileName).readAsStringSync();
    final node = XmlDocument.parse(xml).rootElement;
    return XmlParser(node);
  }
}
```

If, for example, all your tsx files are in one directory, 
adding only one RelativeTsxProvider can allow the Parser to find all of them.

```dart
class RelativeTsxProvider extends TsxProviderBase {
  final String root;

  RelativeTsxProvider(this.root);

  @override
  bool canProvide(String filename) {
    if (cache.containsKey(filename)) return true;

    final exists = File(paths.join(root, filename)).existsSync();
    if (exists) cache[filename] = null;

    return exists;
  }

  Map<String, Parser?> cache = {};

  @override
  Parser? getCachedSource(String filename) => cache[filename];

  @override
  Parser getSource(String filename) {
    final xml = XmlDocument.parse(File(paths.join(root, filename)).readAsStringSync());
    final element = xml.getElement("tileset");
    if (element == null) {
      throw ParsingException(
        "tileset",
        null,
        "This tsx file does not seem to contain a top-level tileset tag",
      );
    }

    cache[filename] = XmlParser(element);
    return cache[filename]!;
  }
}
```

These providers are passed to the parseTmx or parseJson method. 
Keep in mind that the first Provider that can provide a source is used!

```dart
    final String tmxBody = /* ... */;
    final TiledMap mapTmx = TiledMap.parseTmx(
        tmxBody, 
        tsxProviders: [SingleTsxProvider(), MultipleTsxProvider()],
    );
```

### Load Json Files
Alternatively load a json file.
```dart
    final String jsonBody = /* ... */;
    final TiledMap mapTmx = TiledMap.parseJson(jsonBody);
```

### Implementation

For further information and more usage examples, please take a look at the examples in [flame_tiled](https://github.com/flame-engine/flame_tiled).
