import 'package:flutter/material.dart';
import 'package:jsonschema/json_form/models/models.dart';

class DropDownJFormField extends StatefulWidget {
  const DropDownJFormField({
    Key? key,
    required this.property,
    required this.onSaved,
  }) : super(key: key);

  final SchemaProperty property;
  final void Function(dynamic)? onSaved;

  @override
  _DropDownJFormFieldState createState() => _DropDownJFormFieldState();
}

class _DropDownJFormFieldState extends State<DropDownJFormField> {
  @override
  Widget build(BuildContext context) {
    assert(widget.property.enumm != null, 'enum is required');
    assert(() {
      if (widget.property.enumNames != null) {
        return widget.property.enumNames!.length ==
            widget.property.enumm!.length;
      }
      return true;
    }(), '[enumNames] and [enum]  must be the same size ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.property.required
              ? widget.property.title + ' *'
              : widget.property.title,
          style: Theme.of(context).textTheme.caption,
        ),
        DropdownButtonFormField<dynamic>(
          value: widget.property.defaultValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          hint: const Text('Seleccione'),
          isExpanded: false,
          validator: (value) {
            print('valian $value');
            if (widget.property.required && value == null) {
              return 'required';
            }
          },
          items: _buildItems(),
          onChanged: (value) {
            print(value);
          },
          onSaved: widget.onSaved,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  List<DropdownMenuItem> _buildItems() {
    final w = <DropdownMenuItem>[];
    for (var i = 0; i < widget.property.enumm!.length; i++) {
      final value = widget.property.enumm![i];
      final text = widget.property.enumNames?[i] ?? value;
      w.add(
        DropdownMenuItem(
          child: Text(text.toString()),
          value: value,
        ),
      );
    }
    return w;
  }
}
