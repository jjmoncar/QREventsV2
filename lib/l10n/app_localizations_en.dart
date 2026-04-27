// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Guestly';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Full name';

  @override
  String hello(String name) {
    return 'Hello, $name! 👋';
  }

  @override
  String get myNextEvent => 'My Next Event';

  @override
  String get countdown => 'Countdown';

  @override
  String get scanGuests => 'SCAN GUESTS';

  @override
  String get quickGuestList => 'Quick Guest List';

  @override
  String get search => 'Search';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get pending => 'Pending';

  @override
  String get sendInvitation => 'Send Invitation';

  @override
  String get viewDetails => 'View Details';

  @override
  String get myEvents => 'My Events';

  @override
  String get newEvent => 'New Event';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get analytics => 'Analytics';

  @override
  String get guests => 'Guests';

  @override
  String get addGuest => 'Add Guest';

  @override
  String get estimatedAttendance => 'Estimated Attendance';

  @override
  String get totalInvited => 'Total Invited';

  @override
  String get checkedIn => 'Checked In';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get createEvent => 'Create Event';

  @override
  String get eventType => 'Event Type';

  @override
  String get eventName => 'Event name';

  @override
  String get eventDate => 'Date';

  @override
  String get eventTime => 'Time';

  @override
  String get eventLocation => 'Location';

  @override
  String get maxGuests => 'Max capacity';

  @override
  String get accessGranted => 'Access Granted';

  @override
  String get invalidCode => 'Invalid Code';

  @override
  String get alreadyCheckedIn => 'Already Entered';

  @override
  String get partialAccess => 'Partial Access';

  @override
  String get userManagementSubtitle => 'Smart guest management';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get emailInvalid => 'Invalid email';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get passwordTooShort => 'At least 6 characters';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get registerNow => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginNow => 'Login';

  @override
  String get createAccount => 'Create Account';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get nameHint => 'Enter your name';

  @override
  String get noEventsFound => 'No upcoming events found\nCreate your first event 🎉';

  @override
  String get total => 'Total';

  @override
  String get noGuestsFound => 'No guests found yet.\nAdd guests to your event.';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get event_wedding => 'Wedding';

  @override
  String get event_birthday => 'Birthday';

  @override
  String get event_corporate => 'Corporate';

  @override
  String get event_quinceanera => 'Quinceañera';

  @override
  String get event_graduation => 'Graduation';

  @override
  String get event_concert => 'Concert';

  @override
  String get event_other => 'Other';

  @override
  String get noEventsYet => 'No events found';

  @override
  String get eventCreatedSuccess => 'Event created successfully 🎉';

  @override
  String get enterEventName => 'Enter event name';

  @override
  String get enterCapacity => 'Enter capacity';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get eventDescription => 'Description (optional)';

  @override
  String get eventNotFound => 'Event not found';

  @override
  String guestsCount(int count) {
    return '$count guests';
  }

  @override
  String get scan => 'Scan';

  @override
  String get guestSummary => 'Guest Summary';

  @override
  String get checkIn => 'Check-in';

  @override
  String get searchGuest => 'Search guest...';

  @override
  String get deleteGuest => 'Delete Guest';

  @override
  String deleteGuestConfirm(String name) {
    return 'Delete $name?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get people => 'people';

  @override
  String guestAddedSuccess(String name) {
    return '$name added ✅';
  }

  @override
  String get guestNameHint => 'Guest name or family name';

  @override
  String get peopleCount => 'Number of people';

  @override
  String get individualInvitation => 'Individual invitation';

  @override
  String groupInvitation(int count) {
    return 'Group invitation ($count people)';
  }

  @override
  String get contactData => 'Contact Info (at least one)';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get telegram => 'Telegram';

  @override
  String get phone => 'Phone';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get qrScanner => 'QR Scanner';

  @override
  String get peopleEntering => 'People entering: ';

  @override
  String get pointCameraAtQr => 'Point camera at QR code';

  @override
  String remainingSlots(int count) {
    return 'Remaining slots: $count';
  }

  @override
  String get continueScanning => 'CONTINUE SCANNING';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get user => 'User';

  @override
  String get admin => 'Administrator';

  @override
  String get staff => 'Staff';

  @override
  String get help => 'Help';

  @override
  String get about => 'About';

  @override
  String get confirmedVsPending => 'Confirmed vs Pending';

  @override
  String get perEvent => 'Per Event';

  @override
  String get checkIns => 'check-ins';

  @override
  String get appearance => 'Appearance';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get info => 'Information';

  @override
  String get version => 'Version';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get registrationSuccessMessage => 'Registration successful. Please check your email to verify your account.';

  @override
  String get events => 'Events';

  @override
  String invitationMessage(String guestName, String eventName, String link) {
    return 'Hi $guestName! You are invited to $eventName. Your QR invitation is: $link';
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
}
