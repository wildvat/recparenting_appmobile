import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recparenting/_shared/ui/widgets/snack_bar.widget.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/navigator_key.dart';
import 'package:recparenting/src/current_user/helpers/current_user_builder.dart';
import 'package:recparenting/src/notifications/bloc/notification_bloc.dart';
import 'package:recparenting/src/notifications/models/notification_type.enum.dart';
import '../models/user.model.dart';

class ActionNotificationPush {
  RemoteMessage message;
  BuildContext context;
  late User currentUser;

  ActionNotificationPush({required this.message, required this.context}) {
    currentUser = CurrentUserBuilder().value();
    print('entro en action notification push');
    //  dev.log(this.message.data);
  }

  redirectFromPush(String route, dynamic arguments) async {
    //dev.log('redirectFromPush');
    /*
    user ??= await CurrentUserApi().getUser(message.data['user']);

    if (user != null) {

          'App\\Domain\\User\\Model\\Follow') {
    navigatorKey.currentState!
        .pushNamed(homeRoute);
    return;
    }*/
    navigatorKey.currentState!.pushNamed(route, arguments: arguments);
  }

  execute(NotificationBloc notificationsBloc) async {
    print('message entrado');
    notificationsBloc.add(const NotificationsFetch(page: 1));

    NotificationType notificationType = convertNotificationTypeFromString(message.data['type']);
    String? notifiableId =
        message.data['notifiable_uuid']; //Patient id or Therapist id
    String? notifiableType =
        message.data['notifiable_type']; //Patient or Therapist
    String? actionId = message.data['action_id'];

  bool showSnackBar = false;
  Function()? onPress;
  String? title = message.notification?.title;

    switch (notificationType) {
      case NotificationType.therapistDisabledAtNotificationPatient:
        print('therapistDisabledAtNotificationPatient');
        break;
      case NotificationType.therapistDisabledAtNotificationTherapist:
        print('therapistDisabledAtNotificationTherapist');
        break;
      case NotificationType.toPatientWhenTherapistWasAssigned:
        print('toPatientWhenTherapistWasAssigned');
        break;
      case NotificationType.userDisabledAtNotification:
        print('userDisabledAtNotification');
        break;
      case NotificationType.patientDisabledAtNotification:
        print('patientDisabledAtNotification');
        break;
      case NotificationType.toTherapistWhenPatientWasAssigned:
        print('toTherapistWhenPatientWasAssigned');
        break;
      case NotificationType.toTherapistDisabledWhenPatientWasAssigned:
        print('toTherapistDisabledWhenPatientWasAssigned');
        break;
      case NotificationType.toPatientWhenRequestedChange:
        print('toPatientWhenRequestedChange');
        break;
      case NotificationType.toTherapistWhenPatientRequestedChange:
        print('toTherapistWhenPatientRequestedChange');
        break;
      case NotificationType.toParticipantsWhenEventAppointmentWasCreated:
        print('toParticipantsWhenEventAppointmentWasCreated');
        showSnackBar = true;
        break;
      case NotificationType.toParticipantsWhenEventAppointmentWasDeleted:
        print('toParticipantsWhenEventAppointmentWasDeleted');
        break;
      case NotificationType.toEmployeeWhenPatientRequestedChange:
        print('toEmployeeWhenPatientRequestedChange');
        break;
      case NotificationType.toParticipantsWhenForumMessageWasCreated:
        print('toParticipantsWhenForumMessageWasCreated');
        break;
      case NotificationType.patientDisabledAtReminderNotification:
        print('patientDisabledAtReminderNotification');
        break;
      case NotificationType.toTherapistWhenPatientDisabledAtNotification:
        print('toTherapistWhenPatientDisabledAtNotification');
        break;
      case NotificationType.conversationUnreadNotification:
        print('conversationUnreadNotification');
        break;
        case NotificationType.receiveMessageNotification:
          //el action id aqui se corresponde con un conversation id
        onPress = redirectFromPush(chatRoute, actionId);
        print('receiveMessageNotification');
        break;
      default:
        print('default');
    }

    if(showSnackBar && title != null){
      SnackBarRec(message: title, backgroundColor: Colors.blueAccent.shade400, onPress: onPress);
    }
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
