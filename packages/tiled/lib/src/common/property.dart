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
class Property {
  String name;
  PropertyType type;
  // TODO(luan): support other property types
  String value;

  Property({
    required this.name,
    required this.type,
    required this.value,
  });

  Property.parse(Parser parser)
      : this(
          name: parser.getString('name'),
          type: parser.getPropertyType('type', defaults: PropertyType.string),
          value: parser.getString('value'),
        );
}

extension PropertiesParser on Parser {
  Map<String, Property> getProperties() {
    final properties = formatSpecificParsing(
      (json) => json.getChildrenAs('properties', Property.parse),
      (xml) =>
          xml
              .getSingleChildOrNull('properties')
              ?.getChildrenAs('property', Property.parse) ??
          [],
    );

    return properties.groupFoldBy((prop) => prop.name, (previous, element) {
      if (previous != null) {
        throw ArgumentError("Can't have two properties with the same name.");
      }
      return element;
    });
  }
}
