import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/bloc/conversation_bloc.dart';
import 'package:recparenting/src/room/models/conversation.model.dart';
import 'package:recparenting/src/room/models/message.model.dart';
import 'package:recparenting/src/room/providers/pusher.provider.dart';
import '../../providers/encryptMessage.dart';

class ChatScreen extends StatefulWidget {
  final Patient patient;

  const ChatScreen({required this.patient, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatApi _chatApi;
  late ConversationBloc _conversationBloc;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  Conversation? _conversation;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _conversationBloc = ConversationBloc(roomId: widget.patient.room)
      ..add(ConversationFetch(page: page));
    _chatApi = ChatApi(_conversationBloc);
    _chatApi.connect(widget.patient.room);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {

        page++;
        print(page);
        _conversationBloc.add(ConversationFetch(page: page));

    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        body: BlocBuilder<ConversationBloc, ConversationState>(
            bloc: _conversationBloc,
            builder: (context, state) {
              print('estoy en estado $state');
              if (state is ConversationLoaded) {
                print('entro en loades don ${state.messages.messages.length} ');
                return Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.messages.messages.length
                        ? Container()
                        : messageWidget(state.messages.messages[index]!);
                  },
                  itemCount: state.hasReachedMax
                      ? state.messages.messages.length
                      : state.messages.messages.length + 1,
                  controller: _scrollController,
                ));
              }

              if (state is ConversationUninitialized) {
                return const Center(child: CircularProgressIndicator());
              }

              return const Text('no hay datos');
            }));
  }

  Widget messageWidget(Message message) {
    Color backgroundColor = Colors.white;
    Color textColor = Colors.black;
    Alignment alignment = Alignment.centerLeft;
    if (message.user.id == widget.patient.id) {
      backgroundColor = colorRecLight;
      textColor = Colors.white;
      alignment = Alignment.centerRight;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: alignment,
        decoration: BoxDecoration(color: backgroundColor),
        child: Text(decryptAESCryptoJS(message.message, message.user.id),
            style: TextStyle(
              color: textColor,
              fontSize: 18,
            )));
  }
}
