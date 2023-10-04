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
  receiveMessageNotification //only for push notification
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
    case 'ReceiveMessageNotification':
      value = NotificationType.receiveMessageNotification;
      break;
    default:
      value = NotificationType.therapistDisabledAtNotificationTherapist;
      break;
  }
  return value;
}

String convertStringFromNotificationType(NotificationType type) {
  late String value;
  switch (type) {
    case  NotificationType.therapistDisabledAtNotificationPatient:
      value = 'TherapistDisabledAtNotificationPatient';
      break;
    case  NotificationType.therapistDisabledAtNotificationTherapist:
      value = 'TherapistDisabledAtNotificationTherapist';
      break;
    case  NotificationType.toPatientWhenTherapistWasAssigned:
      value = 'ToPatientWhenTherapistWasAssigned';
      break;
    case  NotificationType.userDisabledAtNotification:
      value = 'UserDisabledAtNotification';
      break;
    case  NotificationType.patientDisabledAtNotification:
      value = 'PatientDisabledAtNotification';
      break;
    case  NotificationType.toTherapistWhenPatientWasAssigned:

      value = 'ToTherapistWhenPatientWasAssigned';
      break;
    case  NotificationType.toTherapistDisabledWhenPatientWasAssigned:
      value = 'ToTherapistDisabledWhenPatientWasAssigned';
      break;
    case  NotificationType.toPatientWhenRequestedChange:
      value = 'ToPatientWhenRequestedChange';
      break;
    case  NotificationType.toTherapistWhenPatientRequestedChange:
      value = 'ToTherapistWhenPatientRequestedChange';
      break;
    case  NotificationType.toParticipantsWhenEventAppointmentWasCreated:
      value = 'ToParticipantsWhenEventAppointmentWasCreated';
      break;
    case  NotificationType.toParticipantsWhenEventAppointmentWasDeleted:
      value = 'ToParticipantsWhenEventAppointmentWasDeleted';
      break;
    case  NotificationType.toEmployeeWhenPatientRequestedChange:
      value = 'ToEmployeeWhenPatientRequestedChange';
      break;
    case  NotificationType.toParticipantsWhenForumMessageWasCreated:
      value = 'ToParticipantsWhenForumMessageWasCreated';
      break;
    case  NotificationType.patientDisabledAtReminderNotification:
      value = 'PatientDisabledAtReminderNotification';
      break;
    case  NotificationType.toTherapistWhenPatientDisabledAtNotification:
      value = 'ToTherapistWhenPatientDisabledAtNotification';
      break;
    case  NotificationType.conversationUnreadNotification:
      value = 'ConversationUnreadNotification';
      break;
    case  NotificationType.receiveMessageNotification:
      value = 'ReceiveMessageNotification';
      break;
    default:
      value = 'ConversationUnreadNotification';
      break;
  }
  return value;
}
