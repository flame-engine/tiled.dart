import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

class ParsingException implements Exception {
  final String name;
  final String? valueFound;
  final String reason;

  ParsingException(this.name, this.valueFound, this.reason);
}

class XmlParser extends Parser {
  final XmlElement element;

  XmlParser(this.element, {super.providers});

  XmlParser.fromString(String string, {super.providers})
    : element = XmlDocument.parse(string).rootElement;

  XmlParser._(this.element, super.externalFiles, super.directory) : super._();

  @override
  String? getInnerTextOrNull() =>
      element.innerText.isEmpty ? null : element.innerText;

  @override
  String? getStringOrNull(String name, {String? defaults}) {
    return element.getAttribute(name) ?? defaults;
  }

  @override
  List<Parser> getChildren(String name) => getChildrenWithNames({name});

  List<Parser> getChildrenWithNames(Set<String> names) {
    return element.children
        .whereType<XmlElement>()
        .where((e) => names.contains(e.name.local))
        .map((e) => XmlParser._(e, _externalFiles, _directory))
        .toList();
  }

  @override
  T formatSpecificParsing<T>(
    T Function(JsonParser) json,
    T Function(XmlParser) xml,
  ) {
    return xml(this);
  }

  @override
  XmlParser _inScope(_ExternalFiles externalFiles, String directory) {
    return XmlParser._(element, externalFiles, directory);
  }
}

class JsonParser extends Parser {
  final Map<String, dynamic> json;

  JsonParser(this.json, {super.providers});

  JsonParser.fromString(String string, {super.providers})
    : json = jsonDecode(string) as Map<String, dynamic>;

  JsonParser._(this.json, super.externalFiles, super.directory) : super._();

  @override
  String? getInnerTextOrNull() => null;

  @override
  String? getStringOrNull(String name, {String? defaults}) {
    return json[name]?.toString() ?? defaults;
  }

  @override
  List<Parser> getChildren(String name) {
    final value = json[name];
    final List<dynamic> values;
    if (value == null) {
      return [];
    } else if (value is Map<String, dynamic>) {
      values = [value];
    } else if (value is List<dynamic>) {
      values = value;
    } else {
      throw ParsingException(
        name,
        value.toString(),
        'Expected an object or a list',
      );
    }
    return values
        .map(
          (dynamic e) => JsonParser._(
            e as Map<String, dynamic>,
            _externalFiles,
            _directory,
          ),
        )
        .toList();
  }

  @override
  T formatSpecificParsing<T>(
    T Function(JsonParser) json,
    T Function(XmlParser) xml,
  ) {
    return json(this);
  }

  @override
  JsonParser _inScope(_ExternalFiles externalFiles, String directory) {
    return JsonParser._(json, externalFiles, directory);
  }

  List<int> getIntList(String name) {
    return json[name] as List<int>;
  }
}

abstract class Parser {
  final _ExternalFiles _externalFiles;

  /// The directory, relative to the map, of the file this parser was created
  /// from. Empty for the map itself.
  final String _directory;

  Parser({List<ParserProvider> providers = const []})
    : _externalFiles = _ExternalFiles(providers),
      _directory = '';

  Parser._(this._externalFiles, this._directory);

  /// The providers used to resolve external files, like external tilesets and
  /// object templates, that are referenced from the parsed content.
  ///
  /// See [ParserProvider].
  List<ParserProvider> get providers => _externalFiles.providers;

  /// Creates an [XmlParser] or a [JsonParser] for [contents], depending on
  /// whether the contents are a json object or an xml document.
  factory Parser.fromString(
    String contents, {
    List<ParserProvider> providers = const [],
  }) {
    if (contents.trimLeft().startsWith('{')) {
      return JsonParser.fromString(contents, providers: providers);
    }
    return XmlParser.fromString(contents, providers: providers);
  }

  String? getInnerTextOrNull();

  String? getStringOrNull(String name, {String? defaults});

  List<Parser> getChildren(String name);

  T formatSpecificParsing<T>(
    T Function(JsonParser) json,
    T Function(XmlParser) xml,
  );

  /// Returns a parser for the same content as this one that resolves external
  /// files through [externalFiles], relative to [directory].
  Parser _inScope(_ExternalFiles externalFiles, String directory);

  /// Parses the external file referenced by [path] with [parse], or returns
  /// null when [path] is null or no provider can provide the file.
  ///
  /// [path] is written relative to the file this parser was created from and
  /// is resolved to a path relative to the map before it is passed to the
  /// [providers]. References inside the external file are resolved the same
  /// way, so external files can reference other external files.
  ///
  /// Every file is requested from the providers and parsed at most once per
  /// map, and a file that references itself, directly or through other files,
  /// is left unresolved at the point where the cycle would start.
  T? getExternalOrNullAs<T extends Object>(
    String? path,
    T Function(Parser) parse,
  ) {
    if (path == null) {
      return null;
    }
    return _externalFiles.parse(resolvePath(path), parse);
  }

  /// Resolves [path], written relative to the file this parser was created
  /// from, to a path relative to the map.
  String resolvePath(String path) => _resolvePath(_directory, path);

  List<T> getChildrenAs<T>(String name, T Function(Parser) mapper) {
    return getChildren(name).map(mapper).toList();
  }

  Parser? getSingleChildOrNull(String name) {
    final result = getChildren(name);
    if (result.isEmpty) {
      return null;
    }
    if (result.length > 1) {
      throw ParsingException(
        name,
        null,
        'Multiple children found when one was expected',
      );
    }
    return result[0];
  }

  Parser getSingleChild(String name) {
    final result = getSingleChildOrNull(name);
    if (result == null) {
      throw ParsingException(name, null, 'Required child missing');
    }
    return result;
  }

  T getSingleChildAs<T>(String name, T Function(Parser) parser) {
    return parser(getSingleChild(name));
  }

  T? getSingleChildOrNullAs<T>(String name, T Function(Parser) parser) {
    final result = getSingleChildOrNull(name);
    if (result == null) {
      return null;
    }
    return parser(result);
  }

  String getString(String name, {String? defaults}) {
    final result = getStringOrNull(name, defaults: defaults);
    if (result == null) {
      throw ParsingException(name, null, 'Missing required string field');
    }
    return result;
  }

  double? getDoubleOrNull(String name, {double? defaults}) {
    final value = getStringOrNull(name);
    if (value == null || value == '') {
      return defaults;
    }
    final parsed = double.tryParse(value);
    if (parsed == null) {
      throw ParsingException(
        name,
        value,
        'Double field has unparsable double',
      );
    }
    return parsed;
  }

  double getDouble(String name, {double? defaults}) {
    final result = getDoubleOrNull(name, defaults: defaults);
    if (result == null) {
      throw ParsingException(name, null, 'Missing required double field');
    }
    return result;
  }

  int? getIntOrNull(String name, {int? defaults}) {
    final value = getStringOrNull(name);
    if (value == null || value == '') {
      return defaults;
    }
    final parsed = int.tryParse(value);
    if (parsed == null) {
      throw ParsingException(name, value, 'Int field has unparsable int');
    }
    return parsed;
  }

  int getInt(String name, {int? defaults}) {
    final result = getIntOrNull(name, defaults: defaults);
    if (result == null) {
      throw ParsingException(name, null, 'Missing required int field');
    }
    return result;
  }

  bool? getBoolOrNull(String name, {bool? defaults}) {
    final value = getStringOrNull(name);
    if (value == null || value == '') {
      return defaults;
    }
    if (value == '1' || value == 'true') {
      return true;
    }
    if (value == '0' || value == 'false') {
      return false;
    }
    throw ParsingException(name, value, 'Bool field has unparsable bool');
  }

  bool getBool(String name, {bool? defaults}) {
    final result = getBoolOrNull(name, defaults: defaults);
    if (result == null) {
      throw ParsingException(name, null, 'Missing required bool field');
    }
    return result;
  }

  ColorData? getColorOrNull(String name, {ColorData? defaults}) {
    final tiledColor = getStringOrNull(name);

    // Tiled colors are stored as either ARGB or RGB hex values, so we can
    // parse them as hex numbers with a little coercing.
    int? colorValue;
    if (tiledColor?.length == 7) {
      // parse '#rrbbgg'  as hex '0xaarrggbb' with the alpha channel on full
      colorValue = int.tryParse(tiledColor!.replaceFirst('#', '0xff'));
    } else if (tiledColor?.length == 9) {
      // parse '#aarrbbgg'  as hex '0xaarrggbb'
      colorValue = int.tryParse(tiledColor!.replaceFirst('#', '0x'));
    }

    if (colorValue != null) {
      return ColorData.hex(colorValue);
    } else {
      return defaults;
    }
  }

  ColorData getColor(String name, {ColorData? defaults}) {
    final result = getColorOrNull(name, defaults: defaults);
    if (result == null) {
      throw ParsingException(name, null, 'Missing required color field');
    }
    return result;
  }

  T? getRawEnumOrNull<T>(
    List<T> values,
    String Function(T) namer,
    String name,
    T? defaults,
  ) {
    final value = getStringOrNull(name);
    if (value == null || value == '') {
      return defaults;
    }
    final filteredValues = values.where((e) => namer(e) == value);
    if (filteredValues.isEmpty) {
      throw ParsingException(name, value, 'Missing required enum field');
    }
    return filteredValues.first;
  }

  T getRawEnum<T>(
    List<T> values,
    String Function(T) namer,
    String name,
    T? defaults,
  ) {
    final result = getRawEnumOrNull(values, namer, name, defaults);
    if (result == null) {
      throw ParsingException(name, null, 'Missing required enum field');
    }
    return result;
  }
}

/// The external files of one map, shared by every parser created while parsing
/// it.
class _ExternalFiles {
  final List<ParserProvider> providers;
  final Map<String, Object> parsed = {};
  final Set<String> parsing = {};

  _ExternalFiles(this.providers);

  T? parse<T extends Object>(String path, T Function(Parser) parse) {
    final cached = parsed[path];
    if (cached is T) {
      return cached;
    }
    if (parsing.contains(path)) {
      return null;
    }
    final provider = providers.firstWhereOrNull(
      (provider) => provider.canProvide(path),
    );
    if (provider == null) {
      return null;
    }
    parsing.add(path);
    try {
      final parser = provider.getSource(path)._inScope(this, _dirname(path));
      return parsed[path] = parse(parser);
    } finally {
      parsing.remove(path);
    }
  }
}

String _dirname(String path) {
  final index = path.lastIndexOf('/');
  return index == -1 ? '' : path.substring(0, index);
}

/// Resolves [path], written relative to [directory], to a path relative to
/// the map.
String _resolvePath(String directory, String path) {
  if (directory.isEmpty || path.startsWith('/')) {
    return path;
  }
  final segments = <String>[];
  for (final segment in '$directory/$path'.split('/')) {
    if (segment == '..' && segments.isNotEmpty && segments.last != '..') {
      segments.removeLast();
    } else if (segment != '.' && segment.isNotEmpty) {
      segments.add(segment);
    }
  }
  return segments.join('/');
}
