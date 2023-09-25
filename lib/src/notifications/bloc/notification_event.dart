part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}



class NotificationsFetch extends NotificationEvent {
  final int? page;
  const NotificationsFetch({required this.page});
}