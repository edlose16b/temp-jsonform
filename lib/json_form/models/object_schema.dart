import 'package:jsonschema/json_form/models/models.dart';

class SchemaObject extends Schema {
  SchemaObject({
    required String id,
    this.required = const [],
    String? title,
    String? description,
  }) : super(
          id: id,
          title: title ?? 'no-title',
          type: SchemaType.object,
          description: description,
        );

  // ! Getters
  bool get isGenesis => id == kGenesisIdKey;

  /// array of required keys
  List<String> required;

  List<Schema>? properties;

  factory SchemaObject.fromJson(String id, Map<String, dynamic> json) {
    final schema = SchemaObject(
      id: id,
      title: json['title'],
      description: json['description'],
      required: json["required"] != null
          ? List<String>.from(json["required"].map((x) => x))
          : [],
    );

    schema.setProperties(json['properties'], schema);

    return schema;
  }

  void setProperties(
      Map<String, Map<String, dynamic>> properties, SchemaObject schema) {
    var props = <Schema>[];

    properties.forEach((key, _property) {
      final isRequired = schema.required.contains(key);
      Schema? property;

      property = Schema.fromJson(
        _property,
        id: key,
        parent: schema,
      );

      if (property is SchemaProperty) property.required = isRequired;

      props.add(property);
    });

    this.properties = props;
  }
}
