part of 'notification_bloc.dart';

@immutable
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationsUninitialized extends NotificationState{}

class NotificationsLoaded extends NotificationState {
  final Notifications notifications;
  final bool hasReachedMax;
  final bool loading;
  @override
  const NotificationsLoaded({required this.notifications, required this.hasReachedMax, required this.loading});
  NotificationsLoaded copyWith({
    Notifications? notifications,
    bool? hasReachedMax,
    bool? loading,

  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      loading: loading ?? this.loading,
    );
  }
  @override
  List<Object> get props => [notifications, hasReachedMax];
}
