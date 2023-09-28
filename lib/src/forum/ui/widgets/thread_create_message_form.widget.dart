import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/files_form.widget.dart';
import 'package:recparenting/_shared/ui/widgets/show_files.widget.dart';
import 'package:recparenting/_shared/ui/widgets/snackbar_modal.widget.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/forum/bloc/forum_thread_bloc.dart';
import 'package:recparenting/src/forum/models/forum_message_create_response.model.dart';
import 'package:recparenting/src/forum/providers/forum.provider.dart';

class ThreadCreateMessageForm extends StatefulWidget {
  final String threadId;
  const ThreadCreateMessageForm({required this.threadId, super.key});

  @override
  State<ThreadCreateMessageForm> createState() =>
      _ThreadCreateMessageFormState();
}

class _ThreadCreateMessageFormState extends State<ThreadCreateMessageForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentEditingController =
      TextEditingController();
  FilePickerResult _files = FilePickerResult([]);

  bool _isLoading = false;
  String? _snackbarErrorMessage;

  late ForumThreadBloc _forumThreadBloc;

  @override
  void initState() {
    super.initState();
    _forumThreadBloc = context.read<ForumThreadBloc>();
  }

  @override
  Widget build(BuildContext context) => Form(
      key: _formKey,
      child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom == 0
                      ? 20
                      : MediaQuery.of(context).viewInsets.bottom),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextDefault(
                    AppLocalizations.of(context)!.forumThreadMessageCreateTitle,
                    size: TextSizes.large),
                TextFormField(
                  controller: _commentEditingController,
                  keyboardType: TextInputType.multiline,
                  minLines: 4,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.generalFormRequired;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!
                          .forumThreadMessageCreateComment,
                      hintStyle: const TextStyle(color: Colors.grey)),
                ),
                const SizedBox(height: 10),
                Align(
                    alignment: Alignment.topRight,
                    child: FilesFormWidget(
                      files: _files,
                      onFileDelete: (String fileName) {
                        setState(() {
                          _files.files.removeWhere(
                              (PlatformFile file) => file.name == fileName);
                        });
                      },
                    )),
                const SizedBox(height: 10),
                Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(colorRecDark)),
                        onPressed: () async {
                          final FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                                  allowMultiple: true,
                                  type: FileType.custom,
                                  allowedExtensions: [
                                'zip',
                                'png',
                                'txt',
                                'mp4',
                                'avi',
                                'mp3',
                                'jpeg',
                                'jpg',
                                'gif',
                                'pdf',
                                'doc',
                                'docs',
                                'xls',
                                'xlsx',
                                'odt'
                              ]);
                          if (result != null) {
                            setState(() {
                              _files = result;
                            });
                          }
                        },
                        child: Text(AppLocalizations.of(context)!
                            .forumThreadMessageCreateFiles))),
                const SizedBox(height: 40),
                _snackbarErrorMessage == null
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          SnackbarModal(
                            title: _snackbarErrorMessage!,
                            backgroundColor: Colors.red,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                Stack(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          setState(() {
                            _isLoading = true;
                          });
                          ForumMessageCreateResponse response = await ForumApi()
                              .createMessage(
                                  files: _files.files,
                                  comment: _commentEditingController.text,
                                  threadId: widget.threadId);
                          if (response.error != null && mounted) {
                            setState(() {
                              _isLoading = false;
                              _snackbarErrorMessage = response.error;
                            });
                          } else if (response.message != null && mounted) {
                            setState(() {
                              _isLoading = false;
                              _snackbarErrorMessage = null;
                            });
                            _forumThreadBloc.add(ForumMessageCreated(
                                message: response.message!));
                            SnackBar snackBar = SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .forumThreadCreated),
                              backgroundColor: Colors.green,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pop(context);
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            AppLocalizations.of(context)!.generalSend,
                            textAlign: TextAlign.center,
                          ),
                        )),
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : const SizedBox.shrink()
                  ],
                )
              ]))));
}
