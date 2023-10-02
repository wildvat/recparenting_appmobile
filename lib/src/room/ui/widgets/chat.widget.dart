import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/current_user/helpers/current_user_builder.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/bloc/conversation_bloc.dart';
import 'package:recparenting/src/room/models/conversation.model.dart';
import 'package:recparenting/src/room/models/message.model.dart';
import 'package:recparenting/src/room/providers/pusher.provider.dart';
import '../../../../_shared/models/user.model.dart';
import '../../helpers/time_from_message.dart';
import '../../providers/encryptMessage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatWidget extends StatefulWidget {
  final Patient _patient;

  const ChatWidget({required Patient patient, super.key}) : _patient = patient;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatApi _chatApi;
  late ConversationBloc _conversationBloc;
  late User? _currentUser;
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _currentUser = CurrentUserBuilder().value();
    _conversationBloc = BlocProvider.of<ConversationBloc>(context);
    _conversationBloc.add(ConversationFetch(page: _page));

    if (widget._patient.room != null) {
      _chatApi = ChatApi(context);
      _chatApi.connect(widget._patient.room!);
    }
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter == 0.0) {
      _page++;
      _conversationBloc.add(ConversationFetch(page: _page));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
      List<Widget> widgets = [];
      /*
      Widget reload = IconButton(
          onPressed: () {
            context
                .read<ConversationBloc>()
                .add(const ConversationFetch(page: 1));
          },
          icon: const Icon(Icons.refresh));

      widgets.add(reload);*/

      if (state is ConversationLoaded) {
        if (state.loading) {
          widgets.add(const SizedBox(
              height: 35,
              child: CircularProgressIndicator(
                color: colorRecLight,
              )));
        }
        Widget listChat = Expanded(
            child: ListView.separated(
          scrollDirection: Axis.vertical,
          reverse: true,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          padding: const EdgeInsets.all(8.0),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return index >= state.messages.messages.length
                ? Container()
                : messageWidget(
                    state.conversation,
                    state.messages.messages[index],
                    (index > 0) ? state.messages.messages[index - 1] : null);
          },
          itemCount: state.hasReachedMax
              ? state.messages.messages.length
              : state.messages.messages.length + 1,
          controller: _scrollController,
        ));
        widgets.add(listChat);
        if (state.conversation.room.isActive) {
          widgets.add(textField());
        } else {
          widgets.add(const SizedBox(height: 10));
        }
        return Column(
          children: widgets,
        );
      }

      if (state is ConversationUninitialized) {
        return const Center(child: CircularProgressIndicator());
      }

      return const Text('_');
    });
  }

  bool _shouldShowDateSeparator(Message? previousMessage, Message message) {
    if (previousMessage == null) {
      return true;
    }
    return previousMessage.createdAt
            .difference(message.createdAt)
            .inDays
            .abs() >
        0;
  }

  Widget messageWidget(
      Conversation conversation, Message message, Message? previousMessage) {
    Color backgroundColor = Colors.grey.shade100;
    TextColors textColor = TextColors.dark;
    Alignment alignment = Alignment.centerLeft;
    if (message.user.id == widget._patient.id) {
      backgroundColor = colorRecLight.shade300;
      textColor = TextColors.dark;
      alignment = Alignment.centerRight;
    }
    if (message.isDeleted) {
      textColor = TextColors.muted;
    }

    Widget currentDate = const SizedBox();
    Widget separator = const SizedBox();
    // todo check why date print after message
    if (_shouldShowDateSeparator(previousMessage, message)) {
      currentDate = Center(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.grey.shade300,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextDefault(
                timeToStringFromMessage(message),
                color: TextColors.muted,
                size: TextSizes.small,
              )));
      separator = const SizedBox(
        height: 10,
      );
    }

    return Container(
        constraints: const BoxConstraints(maxWidth: 150),
        alignment: alignment,
        child: Column(
            crossAxisAlignment: (message.user.id != widget._patient.id)
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              currentDate,
              separator,
              GestureDetector(
                  onLongPress: () {
                    if (_currentUser?.id == message.user.id &&
                        conversation.room.isActive) {
                      showAlertRemoveMessage(context, message);
                    }
                  },
                  child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft:
                                  (widget._patient.id == message.user.id)
                                      ? const Radius.circular(20)
                                      : const Radius.circular(0),
                              bottomRight:
                                  (widget._patient.id != message.user.id)
                                      ? const Radius.circular(20)
                                      : const Radius.circular(0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextDefault(
                              decryptAESCryptoJS(
                                  message.message, message.user.id),
                              color: textColor),
                          TextDefault(DateFormat.Hm().format(message.createdAt),
                              size: TextSizes.xsmall,
                              color: TextColors.recDark),
                        ],
                      )))
            ]));
  }

  void sendMessage(String message) {
    Message messageObj = Message(
        '-',
        encryptAESCryptoJS(message, _currentUser!.id),
        'text',
        widget._patient.room!,
        _currentUser!,
        false,
        DateTime.now());
    _conversationBloc.add(AddMessageToConversation(message: messageObj));
  }

  Widget textField() {
    return Container(
        color: Colors.grey.shade200,
        child: TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            hintStyle: const TextStyle(color: colorRecLight),
            hintText: AppLocalizations.of(context)!.chatEnterMessage,
            suffixIcon: IconButton(
              onPressed: () {
                sendMessage(_textController.value.text);
                _textController.clear();
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              icon: const Icon(
                Icons.send,
                color: colorRecLight,
              ),
            ),
          ),
          controller: _textController,
          onChanged: (text) {},
          onSubmitted: (text) {
            sendMessage(text);
            _textController.clear();
          },
        ));
  }

  showAlertRemoveMessage(BuildContext context, Message message) {
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.bold)),
      child: TextDefault(
        AppLocalizations.of(context)!.generalCancel,
        color: TextColors.warning,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.bold)),
      child: TextDefault(
        AppLocalizations.of(context)!.generalContinue,
        color: TextColors.success,
      ),
      onPressed: () {
        message.message = encryptAESCryptoJS(
            'This message has been deleted', message.user.id);
        _conversationBloc.add(DeleteMessageFromConversation(message: message));
        message.isDeleted = true;
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      surfaceTintColor: Colors.white,
      icon: const Icon(Icons.warning, color: Colors.orange),
      backgroundColor: Colors.white,
      title: TextDefault(AppLocalizations.of(context)!.chatDeleteMessageTitle,
          size: TextSizes.medium, fontWeight: FontWeight.bold),
      content:
          TextDefault(AppLocalizations.of(context)!.chatDeleteMessageContent),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierColor: colorRecLight.withOpacity(0.2),
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
