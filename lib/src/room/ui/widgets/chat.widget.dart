import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/bloc/conversation_bloc.dart';
import 'package:recparenting/src/room/models/message.model.dart';
import 'package:recparenting/src/room/providers/pusher.provider.dart';
import '../../../../_shared/models/user.model.dart';
import '../../helpers/time_from_message.dart';
import '../../providers/encryptMessage.dart';

class ChatWidget extends StatefulWidget {
  final Patient patient;

  const ChatWidget({required this.patient, super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatApi chatApi;
  late ConversationBloc conversationBloc;
  late CurrentUserBloc currentUserBloc;
  late User? currentUser;
  final scrollController = ScrollController();
  final scrollThreshold = 200.0;
  final textController = TextEditingController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    currentUserBloc = context.read<CurrentUserBloc>();
    if (currentUserBloc.state is CurrentUserLoaded) {
      currentUser = (currentUserBloc.state as CurrentUserLoaded).user;
    } else {
      throw Exception('no hay usuario');
    }
    conversationBloc = BlocProvider.of<ConversationBloc>(context);
    conversationBloc.add(ConversationFetch(page: page));
    chatApi = ChatApi(context);
    chatApi.connect(widget.patient.room);
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.extentAfter == 0.0) {
      page++;
      conversationBloc.add(ConversationFetch(page: page));
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
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
                : messageWidget(state.messages.messages[index],
                    (index > 0) ? state.messages.messages[index - 1] : null);
          },
          itemCount: state.hasReachedMax
              ? state.messages.messages.length
              : state.messages.messages.length + 1,
          controller: scrollController,
        ));
        widgets.add(listChat);

        widgets.add(textField());
        return Column(
          children: widgets,
        );
      }

      if (state is ConversationUninitialized) {
        return const Center(child: CircularProgressIndicator());
      }

      return const Text('no hay datos');
    });
  }

  bool _shouldShowDateSeparator(Message? previousMessage, Message message) {
    if (previousMessage == null) {
      // Means this is the first message
      return true;
    }
    return previousMessage.createdAt
            .difference(message.createdAt)
            .inDays
            .abs() >
        0;
  }

  Widget messageWidget(Message message, Message? previousMessage) {
    Color backgroundColor = Colors.grey.shade100;
    Color textColor = Colors.black;
    Alignment alignment = Alignment.centerLeft;
    if (message.user.id != widget.patient.id) {
      backgroundColor = colorRecLight.shade300;
      textColor = Colors.black;
      alignment = Alignment.centerRight;
    }
    if (message.isDeleted) {
      //textColor = textColor.withOpacity(0.3);
    }

    Widget currentDate = const SizedBox();
    Widget separator = const SizedBox();
    if (_shouldShowDateSeparator(previousMessage, message)) {
      currentDate = Center(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.grey.shade300,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                timeToStringFromMessage(message),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              )));
      separator = const SizedBox(
        height: 10,
      );

    }
    return Container(
        constraints: const BoxConstraints(maxWidth: 150),
        alignment: alignment,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          currentDate,
          separator,
          GestureDetector(
              onLongPress: () {
                if (currentUser?.id == message.user.id) {
                  showAlertRemoveMessage(context, message);
                }
              },
              child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),

                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: (currentUser!.id == message.user.id)
                              ? const Radius.circular(20)
                              : const Radius.circular(0),
                          bottomRight: (currentUser!.id != message.user.id)
                              ? const Radius.circular(20)
                              : const Radius.circular(0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(decryptAESCryptoJS(message.message, message.user.id),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                          )),
                      Text(DateFormat.Hm().format(message.createdAt),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          )),
                    ],
                  )))
        ]));
  }

  void sendMessage(String message) {
    Message messageObj = Message(
        '-',
        encryptAESCryptoJS(message, currentUser!.id),
        'text',
        widget.patient.room,
        currentUser!,
        false,
        DateTime.now());
    conversationBloc.add(AddMessageToConversation(message: messageObj));
  }

  Widget textField() {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: 'Enter a message',
        suffixIcon: IconButton(
          onPressed: () {
            sendMessage(textController.value.text);
            textController.clear();
          },
          icon: const Icon(Icons.send),
        ),
      ),
      controller: textController,
      onChanged: (text) {},
      onSubmitted: (text) {
        sendMessage(text);
        textController.clear();
      },
    );
  }

  showAlertRemoveMessage(BuildContext context, Message message) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text('cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text('Continue'),
      onPressed: () {
        message.message = encryptAESCryptoJS(
            'This message has been deleted', message.user.id);
        conversationBloc.add(DeleteMessageFromConversation(message: message));
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Vas a borrar un mensaje"),
      content: Text("Estas seguro de querer borrar este mensaje?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
