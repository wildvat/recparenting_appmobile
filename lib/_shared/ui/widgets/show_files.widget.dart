import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/file_rec.model.dart';

class ShowFilesWidget extends StatefulWidget {
  List<FileRec> files;
  ShowFilesWidget({this.files = const [], super.key});

  @override
  State<ShowFilesWidget> createState() => _ShowFilesWidgetState();
}

class _ShowFilesWidgetState extends State<ShowFilesWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.files.isEmpty
          ? const [SizedBox.shrink()]
          : widget.files
              .map((FileRec file) => Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: ElevatedButton(
                        child: Text(file.name), onPressed: () {}),
                  ))
              .toList(),
    );
  }
}
