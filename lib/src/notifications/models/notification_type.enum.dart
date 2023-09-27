enum NotificationType {
  therapistDisabledAtNotificationPatient,
  therapistDisabledAtNotificationTherapist,
  toPatientWhenTherapistWasAssigned,
  userDisabledAtNotification,
  patientDisabledAtNotification,
  toTherapistWhenPatientWasAssigned,
  toTherapistDisabledWhenPatientWasAssigned,
  toPatientWhenRequestedChange,
  toTherapistWhenPatientRequestedChange,
  toParticipantsWhenEventAppointmentWasCreated,
  toParticipantsWhenEventAppointmentWasDeleted,
  toEmployeeWhenPatientRequestedChange,
  toParticipantsWhenForumMessageWasCreated,
  patientDisabledAtReminderNotification,
  toTherapistWhenPatientDisabledAtNotification,
  conversationUnreadNotification,
}
NotificationType convertNotificationTypeFromString(String type) {
  late NotificationType value;
  switch (type) {
    case 'TherapistDisabledAtNotificationPatient':
      value = NotificationType.therapistDisabledAtNotificationPatient;
      break;
    case 'TherapistDisabledAtNotificationTherapist':
      value = NotificationType.therapistDisabledAtNotificationTherapist;
      break;
    case 'ToPatientWhenTherapistWasAssigned':
      value = NotificationType.toPatientWhenTherapistWasAssigned;
      break;
    case 'UserDisabledAtNotification':
      value = NotificationType.userDisabledAtNotification;
      break;
    case 'PatientDisabledAtNotification':
      value = NotificationType.patientDisabledAtNotification;
      break;
    case 'ToTherapistWhenPatientWasAssigned':
      value = NotificationType.toTherapistWhenPatientWasAssigned;
      break;
    case 'ToTherapistDisabledWhenPatientWasAssigned':
      value = NotificationType.toTherapistDisabledWhenPatientWasAssigned;
      break;
    case 'ToPatientWhenRequestedChange':
      value = NotificationType.toPatientWhenRequestedChange;
      break;
    case 'ToTherapistWhenPatientRequestedChange':
      value = NotificationType.toTherapistWhenPatientRequestedChange;
      break;
    case 'ToParticipantsWhenEventAppointmentWasCreated':
      value = NotificationType.toParticipantsWhenEventAppointmentWasCreated;
      break;
    case 'ToParticipantsWhenEventAppointmentWasDeleted':
      value = NotificationType.toParticipantsWhenEventAppointmentWasDeleted;
      break;
    case 'ToEmployeeWhenPatientRequestedChange':
      value = NotificationType.toEmployeeWhenPatientRequestedChange;
      break;
    case 'ToParticipantsWhenForumMessageWasCreated':
      value = NotificationType.toParticipantsWhenForumMessageWasCreated;
      break;
    case 'PatientDisabledAtReminderNotification':
      value = NotificationType.patientDisabledAtReminderNotification;
      break;
    case 'ToTherapistWhenPatientDisabledAtNotification':
      value = NotificationType.toTherapistWhenPatientDisabledAtNotification;
      break;
    case 'ConversationUnreadNotification':
      value = NotificationType.conversationUnreadNotification;
      break;
    default:
      value = NotificationType.therapistDisabledAtNotificationTherapist;
      break;
  }
  return value;
}

