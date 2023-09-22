import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/bloc/conversation_bloc.dart';
import 'package:recparenting/src/room/models/message.model.dart';
import 'package:recparenting/src/room/providers/pusher.provider.dart';
import '../../../../_shared/models/user.model.dart';
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
    if(currentUserBloc.state is CurrentUserLoaded){
      currentUser = (currentUserBloc.state as CurrentUserLoaded).user;
    }else{
      throw Exception('no hay usuario');
    }
    conversationBloc = BlocProvider.of<ConversationBloc>(context);
    conversationBloc.add(ConversationFetch(page: page));
    chatApi = ChatApi(context);
    chatApi.connect(widget.patient.room);
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll - currentScroll <= scrollThreshold) {
      //  page++;
      //  print(page);
      // _conversationBloc.add(ConversationFetch(page: page));
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void sendMessage(String message) {
    Message messageObj = Message(
        '-',
        encryptAESCryptoJS(message, currentUser!.id),
        'text',
        widget.patient.room,
        currentUser!,
      false,
      DateTime.now()
    );
    conversationBloc.add(AddMessageToConversation(message: messageObj));
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  print('estoy en estado $state');

                  List<Widget> widgets = [];
                  Widget reload = IconButton(
                      onPressed: () {
                        context.read<ConversationBloc>().add(const ConversationFetch(page: 1));
                      },
                      icon: const Icon(Icons.refresh));

                  widgets.add(reload);

                  if (state is ConversationLoaded) {
                    print('entro en loades don ${state.messages.messages.length} ');
                    Widget listChat = Expanded(
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
                }
    );
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

  Widget textField(){
    return TextField(
      controller: textController,
      onChanged: (text) {
        print('First text field: $text (${text.characters.length})');
      },
      onSubmitted: (text) {
        sendMessage(text);
        textController.clear();
      },
    );
  }
}
