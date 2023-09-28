import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilesFormWidget extends StatefulWidget {
  FilePickerResult? files;
  Function(String) onFileDelete;
  FilesFormWidget({required this.onFileDelete, this.files, super.key});

  @override
  State<FilesFormWidget> createState() => _FilesFormWidgetState();
}

class _FilesFormWidgetState extends State<FilesFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.files != null && widget.files!.files.isEmpty
          ? const [SizedBox.shrink()]
          : widget.files!.files
              .map((PlatformFile file) => Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Chip(
                        label: Text(file.name),
                        onDeleted: () => widget.onFileDelete(file.name)),
                  ))
              .toList(),
    );
  }
}
