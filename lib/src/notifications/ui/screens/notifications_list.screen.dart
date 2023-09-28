import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/src/notifications/bloc/notification_bloc.dart';
import 'package:recparenting/src/notifications/models/notification.model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  Widget getNotification(NotificationRec notification) {
    String title = notification.getTitle(AppLocalizations.of(context)!
        .notificationsType(notification.type.name));


    //
    return Dismissible(
        direction: DismissDirection.startToEnd,
        dismissThresholds: const {DismissDirection.startToEnd: 0.8},
        key: Key(notification.id),
        onDismissed: (direction) {
          _notificationBloc.add(NotificationDelete(notification: notification));
        },
        background: Container(
          color: Colors.red.shade100,
          padding: const EdgeInsets.only(left: 20.0),
          alignment: Alignment.centerLeft,
          child: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
        child: ListTile(
          onTap: () {
            print(notification.notifiableId);
            print(notification.notifiableType);
            print('voy');
            print(notification.getAction()[0]);
            print(notification.getAction()[1]);
            Navigator.pushNamed(context, notification.getAction()[0],
                arguments: notification.getAction()[1]);
          },
        //  trailing: Text(notification.type.name),
          leading: Icon(notification.getIcon()),
          title: TextDefault(title),
          subtitle:
              Text(DateFormat.yMMMMEEEEd().format(notification.createdAt)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
      title: AppLocalizations.of(context)!.menuNotifications,
        body:
        BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
      if (state is NotificationsLoaded) {
        if (state.notifications.total == 0) {
          //TODO translate
          return Center(
            child: Text('No tienes notificaciones'),
          );
        }
        return ListView.separated(
          scrollDirection: Axis.vertical,
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
