import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:recparenting/src/notifications/models/notifications.model.dart';
import 'package:recparenting/src/notifications/providers/notification.provider.dart';
import 'package:equatable/equatable.dart';

part 'notification_state.dart';

part 'notification_event.dart';


class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationApi notificationApi = NotificationApi();

  NotificationBloc()
      : super(NotificationsUninitialized()) {
    on<NotificationsFetch>(_onFetchNotifications);
  }

  _onFetchNotifications(
      NotificationsFetch event,
      Emitter<NotificationState> emit,
      ) async {
    try {

      if (state is NotificationsLoaded) {
        if((state as NotificationsLoaded).hasReachedMax){
          return;
        }
        NotificationsLoaded currentStatus = (state as NotificationsLoaded);
        emit(currentStatus.copyWith(loading: true));
      }

      final Notifications? notifications =await _getNotifications(event.page ?? 1);
      if (notifications == null) {
        return;
      }



      if (state is NotificationsLoaded) {
        NotificationsLoaded currentStatus = (state as NotificationsLoaded);
        bool hasReachedMax = false;

      } else {
        emit(NotificationsLoaded(
            notifications: notifications,
            hasReachedMax: false,
            loading: false
        ));
      }
    } catch (_) {
    }
  }


  Future<Notifications?> _getNotifications(int page) async {
    return await notificationApi.getAll();
  }

}
