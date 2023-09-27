import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/src/notifications/bloc/notification_bloc.dart';
import 'package:recparenting/src/notifications/models/notification.model.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late NotificationBloc _notificationBloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _notificationBloc = context.read<NotificationBloc>();
    _notificationBloc.add(const NotificationsFetch(page: 1));
  }

  Widget getNotification(NotificationRec notification){
    return Dismissible(
      key: Key(notification.id),
        onDismissed: (direction) {
          _notificationBloc.add(NotificationDelete(notification: notification));
        },
        background: Container(
          padding: const EdgeInsets.only(left: 20.0),
          alignment: Alignment.centerLeft,
          child: const Icon(Icons.delete, color: Colors.red,),
        ),
        child: ListTile(
      title: Text(notification.id),
      subtitle: Text(notification.type),
    ));

  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        body:  BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if(state is NotificationsLoaded){

            return ListView.separated(
              scrollDirection: Axis.vertical,
              reverse: true,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10,
                );
              },
              padding: const EdgeInsets.all(8.0),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return index >= state.notifications.notifications.length
                    ? Container()
                    : getNotification(state.notifications.notifications[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.notifications.notifications.length
                  : state.notifications.notifications.length + 1,
              controller: _scrollController,
            );
          }
          return SizedBox();
    }));
  }
}
