import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jsonschema/json_form/models/models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jsonschema/json_form/shared.dart';

extension on PlatformFile {
  File get toFile {
    return File(path!);
  }
}

extension on FilePickerResult {
  List<File> get toFiles {
    return files.map((e) => File(e.path!)).toList();
  }
}

class FileJFormField extends StatefulWidget {
  const FileJFormField({
    Key? key,
    required this.property,
    required this.onSaved,
  }) : super(key: key);
  final SchemaProperty property;
  final void Function(List<File>?) onSaved;

  @override
  _FileJFormFieldState createState() => _FileJFormFieldState();
}

class _FileJFormFieldState extends State<FileJFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   widget.property.title,
        //   style: Theme.of(context).textTheme.headline6,
        // ),
        // const SizedBox(height: 15),
        FormField<List<PlatformFile>>(
          validator: (value) {
            if ((value == null || value.isEmpty) && widget.property.required) {
              return 'Required';
            }
          },
          onSaved: (newValue) {
            if (newValue != null) {
              widget.onSaved(newValue.map((e) => e.toFile).toList());
            }
          },
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                    );

                    if (result != null) {
                      field.didChange(result.files);
                    }
                  },
                  child: const Text('Elegir archivos'),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: field.value?.length ?? 0,
                  itemBuilder: (context, index) {
                    final file = field.value![index];
                    return ListTile(
                      title: Text(file.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 14),
                        onPressed: () {
                          field.didChange(
                            field.value!
                              ..removeWhere(
                                  (element) => element.path == file.path),
                          );
                        },
                      ),
                    );
                  },
                ),
                if (field.hasError) CustomErrorText(text: field.errorText!),
              ],
            );
          },
        ),
      ],
    );
  }
}
