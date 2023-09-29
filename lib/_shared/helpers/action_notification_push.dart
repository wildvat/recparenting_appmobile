import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:recparenting/_shared/ui/widgets/snack_bar.widget.dart';
import 'package:recparenting/src/notifications/bloc/notification_bloc.dart';
import '../models/user.model.dart';

class ActionNotificationPush {
  RemoteMessage message;
  BuildContext context;

  ActionNotificationPush({required this.message, required this.context}) {
    //  dev.log(this.message.data);
  }

  redirectFromPush([User? user]) async {
    //dev.log('redirectFromPush');
    /*
    user ??= await CurrentUserApi().getUser(message.data['user']);

    if (user != null) {

          'App\\Domain\\User\\Model\\Follow') {
    navigatorKey.currentState!
        .pushNamed(homeRoute);
    return;
    }*/
  }

  execute(NotificationBloc notificationsBloc) async {
    try{
      print(message.data);
      /*NotificationRec notification = NotificationRec(
          id: message.data['id'],
          type: convertNotificationTypeFromString(message.data['type']),
          notifiableId: int.parse(message.data['notifiable_id']),
          notifiableType: message.data['notifiable_type'],
          data: NotificationData.fromJson(jsonDecode(message.data['data'])),
          createdAt: DateTime.parse(message.data['created_at']).toLocal()
      );
      notificationsBloc.add(NotificationAdd(notification: notification));*/
      notificationsBloc.add(NotificationsFetch(page: 1));

    } catch (e) {
      print(e.toString());
      print('error parse notification');
    }

    SnackBarRec( message: 'new Notificaion' );
/*
    User? user = await UserApi().getUserById(message.data['user']);
    if (user != null) {
      if (message.data['type'] == 'App\\Domain\\Chat\\Model\\Conversation') {

        _snackText = R.string.notificationNewChatMessage(_user.userName);
        if (routeObserverStik.history.isNotEmpty &&
            routeObserverStik.history.last.settings.name == '/chat_user') {
          //  dev.log(routeObserverStik.history);
          ChatArgument arguments =
          routeObserverStik.history.last.settings.arguments as ChatArgument;
          if (arguments.user.id == _user.id) {
            if (message.data['extra'] != null) {
              Provider.of<NotificationChat>(context, listen: false)
                  .add(ChatMessage.fromJson(jsonDecode(message.data['extra'])));
              return;
            }
          }
        }
      } else if (message.data['type'] == 'App\\Domain\\User\\Model\\Follow') {
        _snackText = R.string.notificationNewFollowMessage(_user.userName);
      } else if (message.data['type'] == 'App\\Domain\\Hook\\Model\\Hook') {
        _snackText = R.string.notificationNewHookMessage(_user.userName);
      }

      ScaffoldMessenger.of(navigatorKeyStik.currentState!.context)
          .showSnackBar(SnackBar(
        content: BodyText(
          _snackText,
          color: Colors.white,
        ),
        action: SnackBarAction(
          textColor: colorStik,
          label: R.string.generalShow,
          onPressed: () => redirectFromPush(_user),
        ),
        duration: Duration(seconds: 5),
      ));

      return;
    }
    */

  }
}
