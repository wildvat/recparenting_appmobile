enum AppointmentTypes {
  appointment_chat,
  appointment_video,
  basic,
  not_available,
  availability;

  static List<AppointmentTypes> patientAppointmentTypes() {
    return [
      AppointmentTypes.appointment_chat,
      AppointmentTypes.appointment_video
    ];
  }

  static List<AppointmentTypes> therapistAppointmentTypes() {
    return [
      AppointmentTypes.basic,
      AppointmentTypes.availability,
      AppointmentTypes.not_available
    ];
  }

  static String getAppointMentTypeString(AppointmentTypes type) {
    return type.toString().replaceAll('AppointmentTypes.', '');
  }
}
