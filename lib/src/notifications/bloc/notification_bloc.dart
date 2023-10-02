import 'package:bloc/bloc.dart';
import 'dart:developer' as develeper;
import 'package:flutter/cupertino.dart';
import 'package:recparenting/src/notifications/models/notification.model.dart';
import 'package:recparenting/src/notifications/models/notifications.model.dart';
import 'package:recparenting/src/notifications/providers/notification.provider.dart';
import 'package:equatable/equatable.dart';

part 'notification_state.dart';

part 'notification_event.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationApi notificationApi = NotificationApi();

  NotificationBloc() : super(NotificationsUninitialized()) {
    on<NotificationsFetch>(_onFetchNotifications);
    on<NotificationDelete>(_onDeleteNotification);
    on<NotificationAdd>(_onAddNotification);
  }
  _onDeleteNotification(
    NotificationDelete event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state is NotificationsLoaded) {
        NotificationsLoaded currentStatus = (state as NotificationsLoaded);
        Notifications notifications = currentStatus.notifications;
        _deleteNotification(event.notification.id);
        notifications.notifications
            .removeWhere((element) => element.id == event.notification.id);
        emit(NotificationsLoading());
        emit(currentStatus.copyWith(
            notifications: notifications, loading: false));
      }
    } catch (_) {
      develeper.log(_.toString());
    }
  }

  _onAddNotification(
    NotificationAdd event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state is NotificationsLoaded) {
        NotificationsLoaded currentStatus = (state as NotificationsLoaded);
        Notifications notifications = currentStatus.notifications;
        notifications.notifications.add(event.notification);
        notifications.total = notifications.total + 1;
        emit(NotificationsLoading());
        emit(currentStatus.copyWith(
            notifications: notifications, loading: false));
      }
    } catch (_) {
      develeper.log(_.toString());
    }
  }

  _onFetchNotifications(
    NotificationsFetch event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      print('entor en fetch notifications');
      if (state is NotificationsLoaded) {
        print('el estado ya es loaded');
        if ((state as NotificationsLoaded).hasReachedMax) {
          print('no uqiero consultar mas');
          return;
        }

        NotificationsLoaded currentStatus = (state as NotificationsLoaded);
        print('hago loading');
        emit(NotificationsLoading());
        emit(currentStatus.copyWith(loading: true));
      }
      print('consulto api');
      final Notifications? notifications =
          await _getNotifications(event.page ?? 1);
      if (notifications == null) {
        print('nnno hay notificaciones');
        return;
      }

      print('cambi el estado a loading');
      emit(NotificationsLoading());

      if (state is NotificationsLoaded) {
        print('si ya esta  en loadaded');

        NotificationsLoaded currentStatus = (state as NotificationsLoaded);
        bool hasReachedMax = false;
        emit(currentStatus.copyWith(
            notifications: notifications,
            hasReachedMax: hasReachedMax,
            loading: false));
      } else {
        print('sno va nuevo');
        emit(NotificationsLoaded(
            notifications: notifications,
            hasReachedMax: false,
            loading: false));
      }
    } catch (_) {
      print(_.toString());
    }
  }

  Future<Notifications?> _getNotifications(int page) async {
    return await notificationApi.getAll();
  }

  Future<void> _deleteNotification(String notificationId) async {
    return await notificationApi.markAsRead(notificationId);
  }
}
