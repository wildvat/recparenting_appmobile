import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/calendar/models/event.model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonAddCalendar extends StatefulWidget{
  final bool isIcon;
  final bool popOnFinish;
  final EventModel event;
  const ButtonAddCalendar({super.key, required this.event, this.isIcon = true, this.popOnFinish = false});

  @override
  State<ButtonAddCalendar> createState() => _ButtonAddCalendarState();
}

class _ButtonAddCalendarState extends State<ButtonAddCalendar> {
  @override
  Widget build(BuildContext context) {

    if(widget.isIcon) {
      return IconButton(onPressed: () async {
        final Event eventToSend = Event(
          title: widget.event.title,
          description: widget.event.description ?? '',
          // location: 'Event location',
          startDate: widget.event.start,
          endDate: widget.event.end,
          iosParams: const IOSParams(
            //  reminder: Duration(/* Ex. hours:1 */), // on iOS, you can set alarm notification after your event.
            // url: 'https://www.example.com', // on iOS, you can set url to your event.
          ),
          androidParams: const AndroidParams(
            emailInvites: [
            ], // on Android, you can add invite emails to your event.
          ),
        );
        await Add2Calendar.addEvent2Cal(eventToSend);
        if(widget.popOnFinish && mounted){
          Navigator.pop(context);
        }
      }, icon: const Icon(Icons.event_available, color: colorRec, size: 30,));
    }
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(colorRec),
      ),
      onPressed: () async {
        final Event eventToSend = Event(
          title: widget.event.title,
          description: widget.event.description ?? '',
         // location: 'Event location',
          startDate: widget.event.start,
          endDate: widget.event.end,
          iosParams: const IOSParams(
          //  reminder: Duration(/* Ex. hours:1 */), // on iOS, you can set alarm notification after your event.
           // url: 'https://www.example.com', // on iOS, you can set url to your event.
          ),
          androidParams: const AndroidParams(
            emailInvites: [], // on Android, you can add invite emails to your event.
          ),
        );
        await Add2Calendar.addEvent2Cal(eventToSend);
        if(widget.popOnFinish && mounted){
          Navigator.pop(context);
        }
      },
      child: TextDefault(AppLocalizations.of(context)!.generalAddToCalendar, color: TextColors.white),
    );
  }
}