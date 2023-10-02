import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/file_rec.model.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/colors.dart';

class ShowFilesWidget extends StatefulWidget {
  List<FileRec> files;
  ShowFilesWidget({this.files = const [], super.key});

  @override
  State<ShowFilesWidget> createState() => _ShowFilesWidgetState();
}

class _ShowFilesWidgetState extends State<ShowFilesWidget> {
  int _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.files.isEmpty
          ? const [SizedBox.shrink()]
          : widget.files
              .map((FileRec file) => Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.file_download,
                          color: colorRecDark,
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                TextColors.light.color)),
                        label: TextDefault(
                          '${file.name} ${_progress > 0 ? _progress == 100 ? '(downloaded)' : '$_progress%' : ''}',
                          color: TextColors.recDark,
                          size: TextSizes.small,
                        ),
                        onPressed: _progress == 100
                            ? null
                            : () async {
                                Dio().download(
                                  file.url,
                                  '/storage/emulated/0/Download/${file.name}',
                                  onReceiveProgress: (rcv, total) {
                                    if (total != -1) {
                                      setState(() {
                                        _progress =
                                            ((rcv / total) * 100).toInt();
                                      });
                                    }
                                  },
                                );
                              }),
                  ))
              .toList(),
    );
  }
}
