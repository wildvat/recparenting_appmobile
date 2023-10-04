import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/snack_bar.widget.dart';
import 'package:recparenting/_shared/ui/widgets/snackbar_modal.widget.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/src/forum/bloc/forum_bloc.dart';
import 'package:recparenting/src/forum/models/forum_create_response.model.dart';
import 'package:recparenting/src/forum/providers/forum.provider.dart';

class ForumCreateThreadFrom extends StatefulWidget {
  const ForumCreateThreadFrom({super.key});

  @override
  State<ForumCreateThreadFrom> createState() => _ForumCreateThreadFromState();
}

class _ForumCreateThreadFromState extends State<ForumCreateThreadFrom> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController =
      TextEditingController();

  bool _isLoading = false;
  String? _snackbarErrorMessage;
  late ForumBloc _forumBloc;

  @override
  void initState() {
    super.initState();
    _forumBloc = context.read<ForumBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleDefault(
                      AppLocalizations.of(context)!.forumThreadCreateTitle,
                      size: TitleSize.large),
                  TextFormField(
                    controller: _titleEditingController,
                    keyboardType: TextInputType.text,
                    minLines: 2,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .generalFormRequired;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context)!.generalFormFieldTitle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionEditingController,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .generalFormRequired;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!
                          .generalFormFieldDescription,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _snackbarErrorMessage == null
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            SnackbarModal(
                              title: _snackbarErrorMessage!,
                              backgroundColor: TextColors.danger.color,
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
                            ForumCreateResponse response = await ForumApi()
                                .createThread(_titleEditingController.text,
                                    _descriptionEditingController.text);

                            if (response.error != null && mounted) {
                              setState(() {
                                _isLoading = false;
                                _snackbarErrorMessage = response.error;
                              });
                            } else if (response.thread != null && mounted) {
                              setState(() {
                                _isLoading = false;
                                _snackbarErrorMessage = null;
                              });
                              _forumBloc.add(
                                  ForumThreadCreated(thread: response.thread!));
                              SnackBarRec(
                                message: AppLocalizations.of(context)!
                                    .forumThreadCreated,
                                backgroundColor: Colors.green,
                              );
                              Navigator.pop(context);
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: TextDefault(
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
                ],
              ))),
    );
  }
}
