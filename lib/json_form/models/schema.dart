import 'package:flutter/foundation.dart';
import 'package:jsonschema/json_form/models/models.dart';

enum SchemaType {
  string,
  number,
  boolean,
  integer,
  object,
  array,
}
SchemaType schemaTypeFromString(String value) {
  return SchemaType.values.where((e) => describeEnum(e) == value).first;
}

class Schema {
  Schema({
    required this.id,
    required this.type,
    this.title = 'no-title',
    this.description,
    this.parent,
  });

  factory Schema.fromJson(
    Map<String, dynamic> json, {
    String id = kNoIdKey,
    Schema? parent,
  }) {
    Schema schema;

    switch (schemaTypeFromString(json['type'])) {
      case SchemaType.object:
        schema = SchemaObject.fromJson(id, json);
        break;

      case SchemaType.array:
        schema = SchemaArray.fromJson(id, json);

        break;

      default:
        schema = SchemaProperty.fromJson(id, json);
        break;
    }

    return schema..parent = parent;
  }

  // props
  String id;
  String title;
  String? description;
  SchemaType type;

  // util props
  Schema? parent;

  /// it lets us know the key in the formData Map {key}
  String get idKey {
    if (parent != null && !parent!.id.contains(kGenesisIdKey)) {
      if (parent!.id == kNoIdKey) {
        return parent!.parent!.idKey + '.' + id;
      }

      return parent!.idKey + '.' + id;
    }
    return id;
  }
}
