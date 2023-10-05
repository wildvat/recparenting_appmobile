import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:recparenting/_shared/providers/route_observer.dart';
import 'package:recparenting/_shared/ui/widgets/snack_bar.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/navigator_key.dart';
import 'package:recparenting/src/notifications/bloc/notification_bloc.dart';
import 'package:recparenting/src/notifications/models/notification_type.enum.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/helpers/participans_from_room.dart';
import 'package:recparenting/src/room/models/conversation.model.dart';
import 'package:recparenting/src/room/providers/room.provider.dart';

class ActionNotificationPush {
  RemoteMessage message;

  ActionNotificationPush({required this.message});

  redirectFromPush( NotificationBloc? notificationsBloc) async {
    if(notificationsBloc != null) {
      notificationsBloc.add(const NotificationsFetch(page: 1));
    }
    NotificationType notificationType =
    convertNotificationTypeFromString(message.data['type']);
    String? actionId = message.data['action_id'];

    switch (notificationType) {
      case NotificationType.toParticipantsWhenEventAppointmentWasCreated:
        navigatorKey.currentState!
              .pushNamed(calendarRoute);
        break;
      case NotificationType.receiveMessageNotification:
      //el action id aqui se corresponde con un conversation id
        if (actionId != null) {
          Conversation? conversation =
          await RoomApi().getConversation(actionId, 1);
          if (conversation != null) {
            Patient? patient = getPatientFromRoom(conversation.room);
            if (patient != null) {
                navigatorKey.currentState!
                    .pushNamed(chatRoute, arguments: patient);
            }
          }
        }
        break;
      case NotificationType.participantJoinedNotification:
        if (actionId != null) {
            navigatorKey.currentState!
                .pushNamed(joinConferenceRoute, arguments: actionId);
        }
    //el action id aqui se corresponde con un conversation id
      default:
    }
  }


  execute(NotificationBloc notificationsBloc) async {
    notificationsBloc.add(const NotificationsFetch(page: 1));
    NotificationType notificationType =
        convertNotificationTypeFromString(message.data['type']);
    String? notifiableId =
        message.data['notifiable_uuid']; //Patient id or Therapist id
    String? notifiableType =
        message.data['notifiable_type']; //Patient or Therapist
    String? actionId = message.data['action_id'];

    bool showSnackBar = false;
    Function()? onPress;

    String? title = message.notification?.title;

    //Si ya estoy en el chat y me llega un mensaje de chat no hago nada
    if (notificationType == NotificationType.receiveMessageNotification &&
        routeObserverRec.history.isNotEmpty &&
        routeObserverRec.history.last.settings.name == chatRoute) {
      return;
    }
    //Si ya estoy en la pantalla de unirse a la conferencia y me llega una notificacion de unirse a la conferencia voy a la pantalla de join
    if (notificationType == NotificationType.participantJoinedNotification &&
        routeObserverRec.history.isNotEmpty &&
        routeObserverRec.history.last.settings.name == conferenceRoute) {
      navigatorKey.currentState!
          .pushNamed(joinConferenceRoute, arguments: actionId);
      return;
    }

    switch (notificationType) {
      case NotificationType.toParticipantsWhenEventAppointmentWasCreated:
        showSnackBar = true;
        onPress = () {
          navigatorKey.currentState!
              .pushNamed(calendarRoute);
        };
        break;
      case NotificationType.receiveMessageNotification:
        //el action id aqui se corresponde con un conversation id
        if (actionId != null) {
          Conversation? conversation =
              await RoomApi().getConversation(actionId, 1);
          if (conversation != null) {
            Patient? patient = getPatientFromRoom(conversation.room);
            if (patient != null) {
              onPress = () {
                navigatorKey.currentState!
                    .pushNamed(chatRoute, arguments: patient);
              };
            }
          }
        }
        showSnackBar = true;
        break;
      case NotificationType.participantJoinedNotification:
        if (actionId != null) {
          onPress = () {
            navigatorKey.currentState!
                .pushNamed(joinConferenceRoute, arguments: actionId);
          };
        }
        showSnackBar = true;
      //el action id aqui se corresponde con un conversation id
      default:
        showSnackBar = false;
    }

    if (showSnackBar && title != null) {
      SnackBarRec(
          message: title,
          backgroundColor: colorRecLight,
          showCloseIcon: false,
          onPress: onPress);
    }
  }
}
