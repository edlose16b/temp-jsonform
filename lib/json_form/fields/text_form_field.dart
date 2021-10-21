import 'package:flutter/material.dart';
import 'package:jsonschema/json_form/models/models.dart';

class TextJFormField extends StatefulWidget {
  const TextJFormField(
      {Key? key, required this.property, required this.onSaved})
      : super(key: key);

  final SchemaProperty property;
  final void Function(String?) onSaved;
  @override
  _TextJFormFieldState createState() => _TextJFormFieldState();
}

class _TextJFormFieldState extends State<TextJFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: (widget.property.autoFocus ?? false),
      keyboardType: getTextInputTypeFromFormat(widget.property.format),
      maxLines: widget.property.widget == "textarea" ? null : 1,
      obscureText: widget.property.format == PropertyFormat.password,
      initialValue: widget.property.defaultValue ?? '',
      onSaved: widget.onSaved,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onEditingComplete: () {
      //   // if (widget.property.emptyValue != null && value.isEmpty) {
      //   //   widget.property.emptyValue!;
      //   // }
      // },
      validator: (String? value) {
        print('Validando??');
        if (widget.property.required && value != null && value.isEmpty) {
          return 'Required';
        }
        if (widget.property.minLength != null &&
            value != null &&
            value.isNotEmpty &&
            value.length <= widget.property.minLength!) {
          return 'should NOT be shorter than ${widget.property.minLength} characters';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: widget.property.required
            ? widget.property.title + ' *'
            : widget.property.title,
        helperText: widget.property.help,
      ),
    );
  }

  TextInputType getTextInputTypeFromFormat(PropertyFormat format) {
    late TextInputType textInputType;

    switch (format) {
      case PropertyFormat.general:
        textInputType = TextInputType.text;
        break;
      case PropertyFormat.password:
        textInputType = TextInputType.visiblePassword;
        break;
      case PropertyFormat.date:
        textInputType = TextInputType.datetime;
        break;
      case PropertyFormat.datetime:
        textInputType = TextInputType.datetime;
        break;
      case PropertyFormat.email:
        textInputType = TextInputType.emailAddress;
        break;
      case PropertyFormat.dataurl:
        textInputType = TextInputType.text;
        break;
      case PropertyFormat.url:
        textInputType = TextInputType.url;
        break;
    }

    return textInputType;
  }
}
