import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/snack_bar.widget.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/src/calendar/models/create_event_api_response.dart';
import 'package:recparenting/src/calendar/models/type_appointments.dart';
import 'package:recparenting/src/calendar/models/type_datepicker.enum.dart';
import 'package:recparenting/src/calendar/providers/calendar_provider.dart';
import 'package:recparenting/src/current_user/helpers/current_user_builder.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';

class CalendarFormCreateEventWidget extends StatefulWidget {
  DateTime? start;
  final EventController eventController;

  CalendarFormCreateEventWidget(
      {required this.eventController, this.start, super.key});

  @override
  State<CalendarFormCreateEventWidget> createState() =>
      _CalendarFormCreateEventWidgetState();
}

class _CalendarFormCreateEventWidgetState
    extends State<CalendarFormCreateEventWidget> {
  late final User _currentUser;
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _startEditingController = TextEditingController();
  final TextEditingController _endEditingController = TextEditingController();
  final DateTime _today = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late List<AppointmentTypes> _appointmentTypes;
  late String _appointmentType;

  @override
  void initState() {
    super.initState();
    if (widget.start != null) {
      _startEditingController.text = widget.start
          .toString()
          .substring(0, widget.start.toString().length - 7);
    }
    _currentUser = CurrentUserBuilder().value();
    if (_currentUser.isPatient()) {
      _appointmentTypes = AppointmentTypes.patientAppointmentTypes();
    } else {
      _appointmentTypes = AppointmentTypes.therapistAppointmentTypes();
    }
    _appointmentType =
        AppointmentTypes.getAppointMentTypeString(_appointmentTypes[0]);
  }

  void _onTap(TypeDatePicker type) async {
    DateTime? dateFormatEnd;
    DateTime? dateFormatStart;
    if (type == TypeDatePicker.end && _endEditingController.text != '') {
      dateFormatEnd = DateTime.parse(_endEditingController.text);
    }
    if (type == TypeDatePicker.start && _startEditingController.text != '') {
      dateFormatStart = DateTime.parse(_startEditingController.text);
    }

    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: (type == TypeDatePicker.start)
            ? dateFormatStart ?? _today
            : dateFormatEnd ?? _today,
        firstDate:
            _today, //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(_today.year + 1, _today.month, _today.day));
    if (pickedDate != null && mounted) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null && mounted) {
        final String datetTime =
            '${pickedDate.toString().substring(0, 10)} ${picked.hour < 10 ? '0${picked.hour}' : picked.hour}:${picked.minute < 10 ? '0${picked.minute}' : picked.minute}';
        if (type == TypeDatePicker.start) {
          _startEditingController.text = datetTime;
        } else {
          _endEditingController.text = datetTime;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.2,
      maxChildSize: 0.75,
      builder: (context, scrollController) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Form(
              key: _formKey,
              child: ListView(controller: scrollController, children: [
                _currentUser.isTherapist()
                    ? TextFormField(
                        controller: _titleEditingController,
                        keyboardType: TextInputType.text,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .generalFormErrorEmail;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: TextSizes.large.size),
                          hintText:
                              AppLocalizations.of(context)!.eventCreateTitle,
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 30),
                TitleDefault(
                    AppLocalizations.of(context)!.eventCreateAppointmentType,
                    size: TitleSize.large),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  isExpanded: true,
                  value: _appointmentType,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _appointmentType = value;
                      });
                    }
                  },
                  items: _appointmentTypes
                      .map((e) => AppointmentTypes.getAppointMentTypeString(e))
                      .toList()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(AppLocalizations.of(context)!
                          .eventType(value)
                          .toUpperCase()),
                    );
                  }).toList(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _startEditingController,
                      keyboardType: TextInputType.datetime,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .generalFormErrorText;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.eventCreateStart,
                      ),
                      onTap: () => _onTap(TypeDatePicker.start),
                    ),
                    Text(
                      AppLocalizations.of(context)!.eventCreateStartHelp,
                      style: const TextStyle(color: Colors.black54),
                    )
                  ],
                ),
                _currentUser.isTherapist()
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _endEditingController,
                              keyboardType: TextInputType.datetime,
                              readOnly: true,
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .generalFormErrorText;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .eventCreateEnd,
                              ),
                              onTap: () => _onTap(TypeDatePicker.end),
                            )
                          ])
                    : const SizedBox.shrink(),
                const SizedBox(height: 30),
                Stack(
                  children: [
                    ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_startEditingController.text == '' ||
                                    (_currentUser.isTherapist() &&
                                        (_endEditingController.text == '' ||
                                            _titleEditingController.text ==
                                                ''))) {
                                  SnackBarRec(
                                      message: AppLocalizations.of(context)!
                                          .eventCreateMessageRequired);
                                  return;
                                }
                                setState(() {
                                  _isLoading = true;
                                });
                                late DateTime endToApi;
                                final DateTime startToApi = DateTime.parse(
                                    _startEditingController.text);
                                if (_currentUser.isPatient()) {
                                  endToApi = DateTime(
                                      startToApi.year,
                                      startToApi.month,
                                      startToApi.day,
                                      startToApi.hour,
                                      startToApi.minute + 55);
                                } else {
                                  endToApi = DateTime.parse(
                                      _endEditingController.text);
                                }
                                CreateEventApiResponse? response =
                                    await CalendarApi().createEvent(
                                  currentUser: _currentUser,
                                  end: endToApi,
                                  start: startToApi,
                                  modelId: _currentUser.isTherapist()
                                      ? ''
                                      : (_currentUser as Patient).therapist!.id,
                                  modelType: _currentUser.isTherapist()
                                      ? ''
                                      : 'Therapist',
                                  title: _currentUser.isTherapist()
                                      ? _titleEditingController.text
                                      : (_currentUser as Patient).nickname ??
                                          (_currentUser as Patient).id,
                                  type: _appointmentType,
                                  userId: _currentUser.id,
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                                if (!mounted) return;
                                if (response.event != null) {
                                  SnackBarRec(
                                      message: AppLocalizations.of(context)!
                                          .eventCreateMessageOk,
                                      backgroundColor: Colors.green);
                                  widget.eventController.add(response.event!);
                                  Navigator.pop(context);
                                  return;
                                } else {
                                  SnackBarRec(
                                      message: AppLocalizations.of(context)!
                                          .generalError);
                                }
                              },
                        child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              AppLocalizations.of(context)!.generalSend,
                              textAlign: TextAlign.center,
                            ))),
                    _isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )
                        : const SizedBox.shrink(),
                  ],
                )
              ])),
        ),
      ),
    );
  }
}
