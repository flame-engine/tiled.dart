part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <property>
/// * name: The name of the property.
/// * type: The type of the property.
///   Can be string (default), int, float, bool, color, file or object
///   (since 0.16, with color and file added in 0.17, and object added in 1.4).
/// * value: The value of the property.
///   (default string is “”, default number is 0, default boolean is “false”,
///   default color is #00000000, default file is “.” (the current file’s
///   parent directory))
class Property<T> with Exportable {
  String name;
  PropertyType type;
  T value;

  Property({
    required this.name,
    required this.type,
    required this.value,
  });

  static Property<Object> parse(Parser parser) {
    final name = parser.getString('name');
    final type = parser.getPropertyType('type', defaults: PropertyType.string);

    switch (type) {
      case PropertyType.object:
        return ObjectProperty(
          name: name,
          value: parser.getInt('value', defaults: 0),
        );

      case PropertyType.color:
        return ColorProperty(
          name: name,
          value: parser.getColor('value', defaults: ColorData.hex(0x00000000)),
          hexValue: parser.getString('value', defaults: '#00000000'),
        );

      case PropertyType.bool:
        return BoolProperty(
          name: name,
          value: parser.getBool('value', defaults: false),
        );

      case PropertyType.float:
        return FloatProperty(
          name: name,
          value: parser.getDouble('value', defaults: 0),
        );

      case PropertyType.int:
        return IntProperty(
          name: name,
          value: parser.getInt('value', defaults: 0),
        );

      case PropertyType.file:
        return FileProperty(
          name: name,
          value: parser.getString('value', defaults: '.'),
        );

      case PropertyType.string:
        final value = parser.formatSpecificParsing((json) {
          return json.getString('value', defaults: '');
        }, (xml) {
          final attrString = parser.getStringOrNull('value');
          if (attrString != null) {
            return attrString;
          } else {
            // In tmx files, multi-line text property values can be stored
            // inside the <property> node itself instead of in the 'value'
            // attribute
            return xml.element.innerText;
          }
        });

        return StringProperty(
          name: name,
          value: value,
        );
    }
  }

  ExportValue get exportValue => value.toString().toExport();

  ExportElement export() => ExportElement('property', {
        'name': name.toExport(),
        'type': type.name.toExport(),
        'value': exportValue,
      }, {});
}

/// A wrapper for a Tiled property set
///
/// Accessing an int value
/// ```dart
/// properties.get<int>('foo') == 3
/// ```
///
/// Accessing an int property:
/// ```dart
/// properties.getProperty<IntProperty>('foo') ==
///     IntProperty(name: 'foo', value: 3);
/// ```
///
/// You can also use an accessor:
/// ```dart
/// properties['foo'] == IntProperty(name: 'foo', value: 3);
/// ```
class CustomProperties extends Iterable<Property<Object>> {
  static const empty = CustomProperties({});

  /// The properties, indexed by name
  final Map<String, Property<Object>> byName;

  const CustomProperties(this.byName);

  /// Get a property value by its name.
  ///
  /// [T] must be the type of the value, which depends on the property type.
  /// The following Tiled properties map to the follow Dart types:
  ///  - int property -> int
  ///  - float property -> double
  ///  - boolean property -> bool
  ///  - string property -> string
  ///  - color property -> ui.Color
  ///  - file property -> string (path)
  ///  - object property -> int (ID)
  T? getValue<T>(String name) {
    return getProperty(name)?.value as T?;
  }

  /// Get a typed property by its name
  T? getProperty<T extends Property<Object>>(String name) {
    return byName[name] as T?;
  }

  /// Get a property by its name
  Property<Object>? operator [](String name) {
    return byName[name];
  }

  /// Returns whether or not a property with [name] exists.
  bool has(String name) {
    return byName.containsKey(name);
  }

  @override
  Iterator<Property<Object>> get iterator => byName.values.iterator;
}

/// [value] is the ID of the object
class ObjectProperty extends Property<int> {
  ObjectProperty({
    required super.name,
    required super.value,
  }) : super(type: PropertyType.object);
}

/// [value] is the color
class ColorProperty extends Property<ColorData> {
  final String hexValue;

  ColorProperty({
    required super.name,
    required super.value,
    required this.hexValue,
  }) : super(type: PropertyType.color);

  @override
  ExportValue get exportValue => value;
}

/// [value] is the string text
class StringProperty extends Property<String> {
  StringProperty({
    required super.name,
    required super.value,
  }) : super(type: PropertyType.string);
}

/// [value] is the path to the file
class FileProperty extends Property<String> {
  FileProperty({
    required super.name,
    required super.value,
  }) : super(type: PropertyType.file);

  @override
  ExportValue get exportValue =>
      value.isNotEmpty ? value.toExport() : '.'.toExport();
}

/// [value] is the integer number
class IntProperty extends Property<int> {
  IntProperty({
    required super.name,
    required super.value,
  }) : super(type: PropertyType.int);
}

/// [value] is the double-percision floating-point number
class FloatProperty extends Property<double> {
  FloatProperty({
    required super.name,
    required super.value,
  }) : super(type: PropertyType.float);
}

/// [value] is the boolean
class BoolProperty extends Property<bool> {
  BoolProperty({
    required super.name,
    required super.value,
  }) : super(type: PropertyType.bool);
}

extension PropertiesParser on Parser {
  CustomProperties getProperties() {
    final properties = formatSpecificParsing(
      (json) => json.getChildrenAs('properties', Property.parse),
      (xml) =>
          xml
              .getSingleChildOrNull('properties')
              ?.getChildrenAs('property', Property.parse) ??
          [],
    );

    // NOTE: two properties should never have the same name, if they do
    // one will simply override the other
    final byName =
        properties.groupFoldBy((prop) => prop.name, (previous, element) {
      return element;
    });

    return CustomProperties(byName);
  }
}
