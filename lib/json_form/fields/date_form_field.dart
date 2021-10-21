import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsonschema/json_form/models/models.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

class DateJFormField extends StatefulWidget {
  const DateJFormField({
    Key? key,
    required this.property,
    required this.onSaved,
  }) : super(key: key);

  final SchemaProperty property;
  final void Function(DateTime?)? onSaved;

  @override
  _DateJFormFieldState createState() => _DateJFormFieldState();
}

class _DateJFormFieldState extends State<DateJFormField> {
  final txtDateCtrl = MaskedTextController(mask: '00-00-0000');

  final formatter = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: txtDateCtrl,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (widget.property.required && (value == null || value.isEmpty)) {
              return 'Required';
            }
          },
          decoration: InputDecoration(
            hintText: 'DD-MM-YYYY',
            labelText: widget.property.required
                ? widget.property.title + ' *'
                : widget.property.title,
            helperText: widget.property.help,
            suffixIcon: IconButton(
              icon: const Icon(Icons.date_range_outlined),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1998),
                  lastDate: DateTime.now(),
                );
                if (date != null) txtDateCtrl.text = formatter.format(date);

                widget.onSaved!(date);
              },
            ),
          ),
        ),
      ],
    );
  }
}
