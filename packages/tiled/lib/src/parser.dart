part of tiled;

class ParsingException implements Exception {
  final String name;
  final String? valueFound;
  final String reason;
  ParsingException(this.name, this.valueFound, this.reason);
}

class XmlParser extends Parser {
  final XmlElement element;
  final Future<TsxProvider> Function(String key)? tsxProviderFunction;

  XmlParser(
    this.element, {
    this.tsxProviderFunction,
  });

  @override
  String? getStringOrNull(String name, {String? defaults}) {
    return element.getAttribute(name) ?? defaults;
  }

  @override
  List<Parser> getChildren(String name) {
    return element.children
        .whereType<XmlElement>()
        .where((e) => e.name.local == name)
        .map(_newChild)
        .toList();
  }

  List<Parser> getChildrenWithNames(Set<String> names) {
    return element.children
        .whereType<XmlElement>()
        .where((e) => names.contains(e.name.local))
        .map(_newChild)
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
  Future<T?> getExternalPropertyOrNull<T>(
    String name,
    T Function(Parser) parser,
  ) async {
    final fileName = getStringOrNull(name);
    if (fileName == null) {
      return null;
    }
    final tsxProvider = await tsxProviderFunction?.call(fileName);
    final result = tsxProvider?.getCachedSource() ?? tsxProvider?.getSource('');
    if (result == null) {
      return null;
    }
    return parser(result);
  }

  XmlParser _newChild(XmlElement element) => XmlParser(
        element,
        tsxProviderFunction: tsxProviderFunction,
      );
}

class JsonParser extends Parser {
  final Map<String, dynamic> json;
  JsonParser(this.json);

  @override
  String? getStringOrNull(String name, {String? defaults}) {
    return json[name]?.toString() ?? defaults;
  }

  @override
  List<Parser> getChildren(String name) {
    if (json[name] == null) {
      return [];
    }
    return (json[name] as List<dynamic>)
        .map((dynamic e) => JsonParser(e as Map<String, dynamic>))
        .toList();
  }

  @override
  T formatSpecificParsing<T>(
    T Function(JsonParser) json,
    T Function(XmlParser) xml,
  ) {
    return json(this);
  }

  List<int> getIntList(String name) {
    return json[name] as List<int>;
  }
}

abstract class Parser {
  String? getStringOrNull(String name, {String? defaults});

  List<Parser> getChildren(String name);

  T formatSpecificParsing<T>(
    T Function(JsonParser) json,
    T Function(XmlParser) xml,
  );

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

  Color? getColorOrNull(String name, {Color? defaults}) {
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
      return Color(colorValue);
    } else {
      return defaults;
    }
  }

  Color getColor(String name, {Color? defaults}) {
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

  Future<T?> getExternalPropertyOrNull<T>(
    String name,
    T Function(Parser) parser,
  ) async {
    return null;
  }
}
