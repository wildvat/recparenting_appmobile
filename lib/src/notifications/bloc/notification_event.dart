part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}


class NotificationDelete extends NotificationEvent {
  final NotificationRec notification;
  const NotificationDelete({required this.notification});
}
class NotificationsFetch extends NotificationEvent {
  final int? page;
  const NotificationsFetch({required this.page});
}