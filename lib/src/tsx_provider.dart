part of tiled;

abstract class TsxProvider {
  String get filename;

  Parser getSource(String filename);

  Parser? getChachedSource();
}
