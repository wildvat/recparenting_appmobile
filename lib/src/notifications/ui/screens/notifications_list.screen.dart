import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/colors.dart';
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
        crossAxisEndOffset: 50,
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
            NotificationAction? notificationAction = notification.getAction();
            if (notificationAction != null) {
              Navigator.pushNamed(context, notificationAction.route,
                  arguments: notificationAction.argument);
              _notificationBloc
                  .add(NotificationDelete(notification: notification));
            }
          },
          isThreeLine: true,
          //  trailing: Text(notification.type.name),
          leading: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Icon(
              notification.getIcon(),
              color: colorRec,
              size: 30,
            ),
          ),
          title: TextDefault(title),
          subtitle: TextDefault(
            DateFormat.yMMMMEEEEd().format(notification.createdAt),
            size: TextSizes.small,
            color: TextColors.muted,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: AppLocalizations.of(context)!.menuNotifications,
        body: BlocBuilder<NotificationBloc, NotificationState>(
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
          return const SizedBox();
        }));
  }
}
