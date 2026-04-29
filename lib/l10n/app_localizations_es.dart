// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Guestly';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get name => 'Nombre completo';

  @override
  String hello(String name) {
    return '¡Hola, $name! 👋';
  }

  @override
  String get myNextEvent => 'Mi Próximo Evento';

  @override
  String get countdown => 'Cuenta regresiva';

  @override
  String get scanGuests => 'ESCANEAR INVITADOS';

  @override
  String get quickGuestList => 'Lista Rápida de Invitados';

  @override
  String get search => 'Buscar';

  @override
  String get confirmed => 'Confirmado';

  @override
  String get pending => 'Pendiente';

  @override
  String get sendInvitation => 'Enviar Invitación';

  @override
  String get viewDetails => 'Ver Detalles';

  @override
  String get myEvents => 'Mis Eventos';

  @override
  String get newEvent => 'Nuevo Evento';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Ajustes';

  @override
  String get analytics => 'Analíticas';

  @override
  String get guests => 'Invitados';

  @override
  String get addGuest => 'Agregar Invitado';

  @override
  String get estimatedAttendance => 'Asistencia Estimada';

  @override
  String get totalInvited => 'Total Invitados';

  @override
  String get checkedIn => 'Confirmados';

  @override
  String get dark_mode => 'Modo Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get createEvent => 'Crear Evento';

  @override
  String get eventType => 'Tipo de Evento';

  @override
  String get eventName => 'Nombre del evento';

  @override
  String get eventDate => 'Fecha';

  @override
  String get eventTime => 'Hora';

  @override
  String get eventLocation => 'Ubicación';

  @override
  String get maxGuests => 'Capacidad máxima';

  @override
  String get accessGranted => 'Acceso Permitido';

  @override
  String get invalidCode => 'Código Inválido';

  @override
  String get alreadyCheckedIn => 'Ya Ingresó';

  @override
  String get partialAccess => 'Acceso Parcial';

  @override
  String get userManagementSubtitle => 'Gestión inteligente de invitados';

  @override
  String get emailHint => 'Ingresa tu correo';

  @override
  String get emailInvalid => 'Correo inválido';

  @override
  String get passwordHint => 'Ingresa tu contraseña';

  @override
  String get passwordTooShort => 'Mínimo 6 caracteres';

  @override
  String get dontHaveAccount => '¿No tienes cuenta? ';

  @override
  String get registerNow => 'Regístrate';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta? ';

  @override
  String get loginNow => 'Inicia Sesión';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get nameHint => 'Ingresa tu nombre';

  @override
  String get noEventsFound => 'No hay eventos próximos\nCrea tu primer evento 🎉';

  @override
  String get total => 'Total';

  @override
  String get noGuestsFound => 'No hay invitados aún.\nAgrega invitados a tu evento.';

  @override
  String get active => 'Activo';

  @override
  String get inactive => 'Inactivo';

  @override
  String get status_pending => 'Pendiente';

  @override
  String get status_completed => 'Realizado';

  @override
  String get status_cancelled => 'Cancelado';

  @override
  String get invitationCancelled => 'Invitación Cancelada';

  @override
  String get event_wedding => 'Boda';

  @override
  String get event_birthday => 'Cumpleaños';

  @override
  String get event_corporate => 'Corporativo';

  @override
  String get event_quinceanera => 'Quinceañera';

  @override
  String get event_graduation => 'Graduación';

  @override
  String get event_concert => 'Concierto';

  @override
  String get event_other => 'Otro';

  @override
  String get noEventsYet => 'No tienes eventos';

  @override
  String get eventCreatedSuccess => 'Evento creado exitosamente 🎉';

  @override
  String get enterEventName => 'Ingresa el nombre del evento';

  @override
  String get enterCapacity => 'Ingresa la capacidad';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get eventDescription => 'Descripción (opcional)';

  @override
  String get eventNotFound => 'Evento no encontrado';

  @override
  String guestsCount(int count) {
    return '$count invitados';
  }

  @override
  String get scan => 'Escanear';

  @override
  String get guestSummary => 'Resumen de Invitados';

  @override
  String get checkIn => 'Check-in';

  @override
  String get searchGuest => 'Buscar invitado...';

  @override
  String get deleteGuest => 'Eliminar Invitado';

  @override
  String deleteGuestConfirm(String name) {
    return '¿Eliminar a $name?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get people => 'personas';

  @override
  String guestAddedSuccess(String name) {
    return '$name agregado ✅';
  }

  @override
  String get guestNameHint => 'Nombre del invitado o familia';

  @override
  String get peopleCount => 'Cantidad de personas';

  @override
  String get individualInvitation => 'Invitación individual';

  @override
  String groupInvitation(int count) {
    return 'Invitación grupal ($count personas)';
  }

  @override
  String get contactData => 'Datos de Contacto (al menos uno)';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get telegram => 'Telegram';

  @override
  String get phone => 'Teléfono';

  @override
  String get notesOptional => 'Notas (opcional)';

  @override
  String get qrScanner => 'Escáner QR';

  @override
  String get peopleEntering => 'Personas ingresando: ';

  @override
  String get pointCameraAtQr => 'Apunta la cámara al código QR';

  @override
  String remainingSlots(int count) {
    return 'Cupos restantes: $count';
  }

  @override
  String get continueScanning => 'CONTINUAR ESCANEANDO';

  @override
  String get dashboard => 'Inicio';

  @override
  String get user => 'Usuario';

  @override
  String get admin => 'Administrador';

  @override
  String get staff => 'Staff';

  @override
  String get help => 'Ayuda';

  @override
  String get about => 'Acerca de';

  @override
  String get confirmedVsPending => 'Confirmados vs Pendientes';

  @override
  String get perEvent => 'Por Evento';

  @override
  String get checkIns => 'check-ins';

  @override
  String get appearance => 'Apariencia';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get info => 'Información';

  @override
  String get version => 'Versión';

  @override
  String get termsOfUse => 'Términos de uso';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get registrationSuccessMessage => 'Registro exitoso. Revisa tu correo para verificar tu cuenta.';

  @override
  String get events => 'Eventos';

  @override
  String invitationMessage(String guestName, String eventName, String link) {
    return '¡Hola $guestName! Estás invitado a $eventName. Tu pase QR es: $link';
  }

  @override
  String get editEvent => 'Editar Evento';

  @override
  String get editGuest => 'Editar Invitado';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get eventUpdatedSuccess => 'Evento actualizado ✅';

  @override
  String get eventDeletedSuccess => 'Evento eliminado';

  @override
  String get deleteEvent => 'Eliminar Evento';

  @override
  String deleteEventConfirm(String title) {
    return '¿Estás seguro de eliminar \'$title\'? Esta acción no se puede deshacer.';
  }

  @override
  String invitationWedding(String guestName, String eventName, String link) {
    return '¡Hola $guestName! Estamos felices de invitarte a nuestra Boda: $eventName. Obtén tu pase QR aquí: $link';
  }

  @override
  String invitationBirthday(String guestName, String eventName, String link) {
    return '¡Hola $guestName! Te espero para celebrar mi cumpleaños: $eventName. Tu pase QR es: $link';
  }

  @override
  String invitationCorporate(String guestName, String eventName, String link) {
    return 'Estimado(a) $guestName, le invitamos formalmente al evento corporativo: $eventName. Su pase de acceso QR: $link';
  }

  @override
  String get retry => 'Reintentar';

  @override
  String get loginRequired => 'Debes iniciar sesión para ver tu perfil';

  @override
  String get errorEmailAlreadyRegistered => 'El correo ya está registrado. Por favor, inicia sesión.';
}
