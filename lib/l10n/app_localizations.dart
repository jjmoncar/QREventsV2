import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Guestly'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get name;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}! 👋'**
  String hello(String name);

  /// No description provided for @myNextEvent.
  ///
  /// In en, this message translates to:
  /// **'My Next Event'**
  String get myNextEvent;

  /// No description provided for @countdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get countdown;

  /// No description provided for @scanGuests.
  ///
  /// In en, this message translates to:
  /// **'SCAN GUESTS'**
  String get scanGuests;

  /// No description provided for @quickGuestList.
  ///
  /// In en, this message translates to:
  /// **'Quick Guest List'**
  String get quickGuestList;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @sendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Send Invitation'**
  String get sendInvitation;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @myEvents.
  ///
  /// In en, this message translates to:
  /// **'My Events'**
  String get myEvents;

  /// No description provided for @newEvent.
  ///
  /// In en, this message translates to:
  /// **'New Event'**
  String get newEvent;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @addGuest.
  ///
  /// In en, this message translates to:
  /// **'Add Guest'**
  String get addGuest;

  /// No description provided for @estimatedAttendance.
  ///
  /// In en, this message translates to:
  /// **'Estimated Attendance'**
  String get estimatedAttendance;

  /// No description provided for @totalInvited.
  ///
  /// In en, this message translates to:
  /// **'Total Invited'**
  String get totalInvited;

  /// No description provided for @checkedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked In'**
  String get checkedIn;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEvent;

  /// No description provided for @eventType.
  ///
  /// In en, this message translates to:
  /// **'Event Type'**
  String get eventType;

  /// No description provided for @eventName.
  ///
  /// In en, this message translates to:
  /// **'Event name'**
  String get eventName;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get eventDate;

  /// No description provided for @eventTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get eventTime;

  /// No description provided for @eventLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get eventLocation;

  /// No description provided for @maxGuests.
  ///
  /// In en, this message translates to:
  /// **'Max capacity'**
  String get maxGuests;

  /// No description provided for @accessGranted.
  ///
  /// In en, this message translates to:
  /// **'Access Granted'**
  String get accessGranted;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid Code'**
  String get invalidCode;

  /// No description provided for @alreadyCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Already Entered'**
  String get alreadyCheckedIn;

  /// No description provided for @partialAccess.
  ///
  /// In en, this message translates to:
  /// **'Partial Access'**
  String get partialAccess;

  /// No description provided for @userManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart guest management'**
  String get userManagementSubtitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get emailInvalid;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerNow;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginNow;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameHint;

  /// No description provided for @noEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events found\nCreate your first event 🎉'**
  String get noEventsFound;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @noGuestsFound.
  ///
  /// In en, this message translates to:
  /// **'No guests found yet.\nAdd guests to your event.'**
  String get noGuestsFound;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @status_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get status_pending;

  /// No description provided for @status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get status_completed;

  /// No description provided for @status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get status_cancelled;

  /// No description provided for @invitationCancelled.
  ///
  /// In en, this message translates to:
  /// **'Invitation Cancelled'**
  String get invitationCancelled;

  /// No description provided for @event_wedding.
  ///
  /// In en, this message translates to:
  /// **'Wedding'**
  String get event_wedding;

  /// No description provided for @event_birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get event_birthday;

  /// No description provided for @event_corporate.
  ///
  /// In en, this message translates to:
  /// **'Corporate'**
  String get event_corporate;

  /// No description provided for @event_quinceanera.
  ///
  /// In en, this message translates to:
  /// **'Quinceañera'**
  String get event_quinceanera;

  /// No description provided for @event_graduation.
  ///
  /// In en, this message translates to:
  /// **'Graduation'**
  String get event_graduation;

  /// No description provided for @event_concert.
  ///
  /// In en, this message translates to:
  /// **'Concert'**
  String get event_concert;

  /// No description provided for @event_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get event_other;

  /// No description provided for @noEventsYet.
  ///
  /// In en, this message translates to:
  /// **'No events found'**
  String get noEventsYet;

  /// No description provided for @eventCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Event created successfully 🎉'**
  String get eventCreatedSuccess;

  /// No description provided for @enterEventName.
  ///
  /// In en, this message translates to:
  /// **'Enter event name'**
  String get enterEventName;

  /// No description provided for @enterCapacity.
  ///
  /// In en, this message translates to:
  /// **'Enter capacity'**
  String get enterCapacity;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @eventDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get eventDescription;

  /// No description provided for @eventNotFound.
  ///
  /// In en, this message translates to:
  /// **'Event not found'**
  String get eventNotFound;

  /// No description provided for @guestsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} guests'**
  String guestsCount(int count);

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @guestSummary.
  ///
  /// In en, this message translates to:
  /// **'Guest Summary'**
  String get guestSummary;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @searchGuest.
  ///
  /// In en, this message translates to:
  /// **'Search guest...'**
  String get searchGuest;

  /// No description provided for @deleteGuest.
  ///
  /// In en, this message translates to:
  /// **'Delete Guest'**
  String get deleteGuest;

  /// No description provided for @deleteGuestConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteGuestConfirm(String name);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'people'**
  String get people;

  /// No description provided for @guestAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{name} added ✅'**
  String guestAddedSuccess(String name);

  /// No description provided for @guestNameHint.
  ///
  /// In en, this message translates to:
  /// **'Guest name or family name'**
  String get guestNameHint;

  /// No description provided for @peopleCount.
  ///
  /// In en, this message translates to:
  /// **'Number of people'**
  String get peopleCount;

  /// No description provided for @individualInvitation.
  ///
  /// In en, this message translates to:
  /// **'Individual invitation'**
  String get individualInvitation;

  /// No description provided for @groupInvitation.
  ///
  /// In en, this message translates to:
  /// **'Group invitation ({count} people)'**
  String groupInvitation(int count);

  /// No description provided for @contactData.
  ///
  /// In en, this message translates to:
  /// **'Contact Info (at least one)'**
  String get contactData;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @telegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get telegram;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @qrScanner.
  ///
  /// In en, this message translates to:
  /// **'QR Scanner'**
  String get qrScanner;

  /// No description provided for @peopleEntering.
  ///
  /// In en, this message translates to:
  /// **'People entering: '**
  String get peopleEntering;

  /// No description provided for @pointCameraAtQr.
  ///
  /// In en, this message translates to:
  /// **'Point camera at QR code'**
  String get pointCameraAtQr;

  /// No description provided for @remainingSlots.
  ///
  /// In en, this message translates to:
  /// **'Remaining slots: {count}'**
  String remainingSlots(int count);

  /// No description provided for @continueScanning.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE SCANNING'**
  String get continueScanning;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get admin;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @confirmedVsPending.
  ///
  /// In en, this message translates to:
  /// **'Confirmed vs Pending'**
  String get confirmedVsPending;

  /// No description provided for @perEvent.
  ///
  /// In en, this message translates to:
  /// **'Per Event'**
  String get perEvent;

  /// No description provided for @checkIns.
  ///
  /// In en, this message translates to:
  /// **'check-ins'**
  String get checkIns;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @registrationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Registration successful. Please check your email to verify your account.'**
  String get registrationSuccessMessage;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @invitationMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi {guestName}! You are invited to {eventName}. Your QR invitation is: {link}'**
  String invitationMessage(String guestName, String eventName, String link);

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get editEvent;

  /// No description provided for @editGuest.
  ///
  /// In en, this message translates to:
  /// **'Edit Guest'**
  String get editGuest;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @eventUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Event updated ✅'**
  String get eventUpdatedSuccess;

  /// No description provided for @eventDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Event deleted'**
  String get eventDeletedSuccess;

  /// No description provided for @deleteEvent.
  ///
  /// In en, this message translates to:
  /// **'Delete Event'**
  String get deleteEvent;

  /// No description provided for @deleteEventConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \'{title}\'? This action cannot be undone.'**
  String deleteEventConfirm(String title);

  /// No description provided for @invitationWedding.
  ///
  /// In en, this message translates to:
  /// **'Hi {guestName}! We are happy to invite you to our Wedding: {eventName}. Get your QR pass here: {link}'**
  String invitationWedding(String guestName, String eventName, String link);

  /// No description provided for @invitationBirthday.
  ///
  /// In en, this message translates to:
  /// **'Hi {guestName}! I\'m waiting for you to celebrate my birthday: {eventName}. Your QR pass is: {link}'**
  String invitationBirthday(String guestName, String eventName, String link);

  /// No description provided for @invitationCorporate.
  ///
  /// In en, this message translates to:
  /// **'Dear {guestName}, you are formally invited to our corporate event: {eventName}. Your QR access pass: {link}'**
  String invitationCorporate(String guestName, String eventName, String link);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to view your profile'**
  String get loginRequired;

  /// No description provided for @errorEmailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Email already registered. Please log in.'**
  String get errorEmailAlreadyRegistered;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
