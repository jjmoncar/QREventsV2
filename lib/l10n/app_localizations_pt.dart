// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Guestly';

  @override
  String get login => 'Entrar';

  @override
  String get register => 'Cadastrar';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get name => 'Nome completo';

  @override
  String hello(String name) {
    return 'Olá, $name! 👋';
  }

  @override
  String get myNextEvent => 'Meu Próximo Evento';

  @override
  String get countdown => 'Contagem regressiva';

  @override
  String get scanGuests => 'ESCANEAR CONVIDADOS';

  @override
  String get quickGuestList => 'Lista Rápida de Convidados';

  @override
  String get search => 'Pesquisar';

  @override
  String get confirmed => 'Confirmado';

  @override
  String get pending => 'Pendente';

  @override
  String get sendInvitation => 'Enviar Convite';

  @override
  String get viewDetails => 'Ver Detalhes';

  @override
  String get myEvents => 'Meus Eventos';

  @override
  String get newEvent => 'Novo Evento';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configurações';

  @override
  String get analytics => 'Análises';

  @override
  String get guests => 'Convidados';

  @override
  String get addGuest => 'Adicionar Convidado';

  @override
  String get estimatedAttendance => 'Presença Estimada';

  @override
  String get totalInvited => 'Total Convidados';

  @override
  String get checkedIn => 'Confirmados';

  @override
  String get dark_mode => 'Modo Escuro';

  @override
  String get language => 'Idioma';

  @override
  String get logout => 'Sair';

  @override
  String get createEvent => 'Criar Evento';

  @override
  String get eventType => 'Tipo de Evento';

  @override
  String get eventName => 'Nome do evento';

  @override
  String get eventDate => 'Data';

  @override
  String get eventTime => 'Hora';

  @override
  String get eventLocation => 'Local';

  @override
  String get maxGuests => 'Capacidade máxima';

  @override
  String get accessGranted => 'Acesso Permitido';

  @override
  String get invalidCode => 'Código Inválido';

  @override
  String get alreadyCheckedIn => 'Já Entrou';

  @override
  String get partialAccess => 'Acesso Parcial';

  @override
  String get userManagementSubtitle => 'Gestão inteligente de convidados';

  @override
  String get emailHint => 'Digite seu e-mail';

  @override
  String get emailInvalid => 'E-mail inválido';

  @override
  String get passwordHint => 'Digite sua senha';

  @override
  String get passwordTooShort => 'Pelo menos 6 caracteres';

  @override
  String get dontHaveAccount => 'Não tem uma conta? ';

  @override
  String get registerNow => 'Registre-se';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta? ';

  @override
  String get loginNow => 'Entrar';

  @override
  String get createAccount => 'Criar Conta';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get nameHint => 'Insira seu nome';

  @override
  String get noEventsFound => 'Nenhum evento próximo encontrado\nCrie seu primeiro evento 🎉';

  @override
  String get total => 'Total';

  @override
  String get noGuestsFound => 'Nenhum convidado encontrado ainda.\nAdicione convidados ao seu evento.';

  @override
  String get active => 'Ativo';

  @override
  String get inactive => 'Inativo';

  @override
  String get status_pending => 'Pendente';

  @override
  String get status_completed => 'Realizado';

  @override
  String get status_cancelled => 'Cancelado';

  @override
  String get invitationCancelled => 'Convite Cancelado';

  @override
  String get event_wedding => 'Casamento';

  @override
  String get event_birthday => 'Aniversário';

  @override
  String get event_corporate => 'Corporativo';

  @override
  String get event_quinceanera => 'Baile de Debutante';

  @override
  String get event_graduation => 'Formatura';

  @override
  String get event_concert => 'Show';

  @override
  String get event_other => 'Outro';

  @override
  String get noEventsYet => 'Nenhum evento encontrado';

  @override
  String get eventCreatedSuccess => 'Evento criado com sucesso 🎉';

  @override
  String get enterEventName => 'Insira o nome do evento';

  @override
  String get enterCapacity => 'Insira a capacidade';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get eventDescription => 'Descrição (opcional)';

  @override
  String get eventNotFound => 'Evento não encontrado';

  @override
  String guestsCount(int count) {
    return '$count convidados';
  }

  @override
  String get scan => 'Escanear';

  @override
  String get guestSummary => 'Resumo de Convidados';

  @override
  String get checkIn => 'Check-in';

  @override
  String get searchGuest => 'Buscar convidado...';

  @override
  String get deleteGuest => 'Excluir Convidado';

  @override
  String deleteGuestConfirm(String name) {
    return 'Excluir $name?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get people => 'pessoas';

  @override
  String guestAddedSuccess(String name) {
    return '$name adicionado ✅';
  }

  @override
  String get guestNameHint => 'Nome do convidado ou família';

  @override
  String get peopleCount => 'Quantidade de pessoas';

  @override
  String get individualInvitation => 'Convite individual';

  @override
  String groupInvitation(int count) {
    return 'Convite em grupo ($count pessoas)';
  }

  @override
  String get contactData => 'Dados de Contato (pelo menos um)';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get telegram => 'Telegram';

  @override
  String get phone => 'Telefone';

  @override
  String get notesOptional => 'Notas (opcional)';

  @override
  String get qrScanner => 'Escaner QR';

  @override
  String get peopleEntering => 'Pessoas ingressando: ';

  @override
  String get pointCameraAtQr => 'Aponte a câmera para o código QR';

  @override
  String remainingSlots(int count) {
    return 'Vagas restantes: $count';
  }

  @override
  String get continueScanning => 'CONTINUAR ESCANEANDO';

  @override
  String get dashboard => 'Início';

  @override
  String get user => 'Usuário';

  @override
  String get admin => 'Administrador';

  @override
  String get staff => 'Equipe';

  @override
  String get help => 'Ajuda';

  @override
  String get about => 'Sobre';

  @override
  String get confirmedVsPending => 'Confirmados vs Pendentes';

  @override
  String get perEvent => 'Por Evento';

  @override
  String get checkIns => 'check-ins';

  @override
  String get appearance => 'Aparência';

  @override
  String get enabled => 'Ativado';

  @override
  String get disabled => 'Desativado';

  @override
  String get info => 'Informação';

  @override
  String get version => 'Versão';

  @override
  String get termsOfUse => 'Termos de uso';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get registrationSuccessMessage => 'Registro efetuado com sucesso. Verifique seu e-mail para confirmar sua conta.';

  @override
  String get events => 'Eventos';

  @override
  String invitationMessage(String guestName, String eventName, String link) {
    return 'Olá $guestName! Você está convidado para o evento $eventName. Seu convite QR é: $link';
  }

  @override
  String get editEvent => 'Edit Event';

  @override
  String get editGuest => 'Edit Guest';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get eventUpdatedSuccess => 'Event updated ✅';

  @override
  String get eventDeletedSuccess => 'Event deleted';

  @override
  String get deleteEvent => 'Delete Event';

  @override
  String deleteEventConfirm(String title) {
    return 'Are you sure you want to delete \'$title\'? This action cannot be undone.';
  }

  @override
  String invitationWedding(String guestName, String eventName, String link) {
    return 'Hi $guestName! We are happy to invite you to our Wedding: $eventName. Get your QR pass here: $link';
  }

  @override
  String invitationBirthday(String guestName, String eventName, String link) {
    return 'Hi $guestName! I\'m waiting for you to celebrate my birthday: $eventName. Your QR pass is: $link';
  }

  @override
  String invitationCorporate(String guestName, String eventName, String link) {
    return 'Dear $guestName, you are formally invited to our corporate event: $eventName. Your QR access pass: $link';
  }

  @override
  String get retry => 'Tentar novamente';

  @override
  String get loginRequired => 'Você deve estar logado para ver seu perfil';
}
