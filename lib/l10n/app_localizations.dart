import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
  ];

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @fieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldIsRequired;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// No description provided for @bioIsTooLong.
  ///
  /// In en, this message translates to:
  /// **'Bio should not exceed {length} characters'**
  String bioIsTooLong(int length);

  /// No description provided for @organizationIsTooLong.
  ///
  /// In en, this message translates to:
  /// **'Organization name should not exceed {length} characters'**
  String organizationIsTooLong(int length);

  /// No description provided for @fieldIsTooLong.
  ///
  /// In en, this message translates to:
  /// **'{field} should not exceed {length} characters'**
  String fieldIsTooLong(String field, int length);

  /// No description provided for @fieldIsTooShort.
  ///
  /// In en, this message translates to:
  /// **'{field} should be at least {length} characters long'**
  String fieldIsTooShort(String field, int length);

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @passwordIsTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password should be at least {length} characters long'**
  String passwordIsTooShort(int length);

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get organization;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcome(String name);

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @larvixon.
  ///
  /// In en, this message translates to:
  /// **'Larvixon'**
  String get larvixon;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @larvixonHeader.
  ///
  /// In en, this message translates to:
  /// **'ML-Powered Diagnostics in Minutes'**
  String get larvixonHeader;

  /// No description provided for @larvixonSubheader.
  ///
  /// In en, this message translates to:
  /// **'A breakthrough system for rapid detection of toxins and drugs.'**
  String get larvixonSubheader;

  /// No description provided for @larvixonDescription.
  ///
  /// In en, this message translates to:
  /// **'Our platform uses artificial intelligence to analyze subtle movement patterns of various larvae exposed to patient plasma. In less than 20 minutes, it delivers highly accurate insights into the presence of xenobiotics — helping doctors act faster, save lives, and improve treatment outcomes.'**
  String get larvixonDescription;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @reachUs.
  ///
  /// In en, this message translates to:
  /// **'Reach us'**
  String get reachUs;

  /// No description provided for @sendUsAMessage.
  ///
  /// In en, this message translates to:
  /// **'Send us a message'**
  String get sendUsAMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'We are a team of passionate developers building modern, responsive apps. Our goal is to deliver high-quality products and collaborate effectively with our stakeholders.'**
  String get aboutDescription;

  /// No description provided for @ourMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get ourMission;

  /// No description provided for @ourMissionDescription.
  ///
  /// In en, this message translates to:
  /// **'To build apps that make life easier for medical staff by providing useful tooling.'**
  String get ourMissionDescription;

  /// No description provided for @ourVision.
  ///
  /// In en, this message translates to:
  /// **'Our Vision'**
  String get ourVision;

  /// No description provided for @ourVisionDescription.
  ///
  /// In en, this message translates to:
  /// **'To innovate continuously and provide seamless digital experiences.'**
  String get ourVisionDescription;

  /// No description provided for @ourTeam.
  ///
  /// In en, this message translates to:
  /// **'Our Team'**
  String get ourTeam;

  /// No description provided for @messageSentAcknowledgment.
  ///
  /// In en, this message translates to:
  /// **'Message sent — thank you!'**
  String get messageSentAcknowledgment;

  /// No description provided for @contactDescription.
  ///
  /// In en, this message translates to:
  /// **'Have a question or want to collaborate? Drop us a message.'**
  String get contactDescription;

  /// No description provided for @uploadNewVideo.
  ///
  /// In en, this message translates to:
  /// **'Upload new video'**
  String get uploadNewVideo;

  /// No description provided for @uploadVideoDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload a new video to the platform to analyze larval movements.'**
  String get uploadVideoDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @selectVideo.
  ///
  /// In en, this message translates to:
  /// **'Select Video'**
  String get selectVideo;

  /// No description provided for @selectedFile.
  ///
  /// In en, this message translates to:
  /// **'Selected: {fileName}'**
  String selectedFile(String fileName);

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @enterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter title'**
  String get enterTitle;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading'**
  String get uploading;

  /// No description provided for @uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploaded;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @analysing.
  ///
  /// In en, this message translates to:
  /// **'Analysing'**
  String get analysing;

  /// No description provided for @analysed.
  ///
  /// In en, this message translates to:
  /// **'Analysed'**
  String get analysed;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @andMore.
  ///
  /// In en, this message translates to:
  /// **'{count} more'**
  String andMore(int count);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign In Failed'**
  String get signInFailed;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'Account Disabled'**
  String get accountDisabled;

  /// No description provided for @mfaRequired.
  ///
  /// In en, this message translates to:
  /// **'Multi-Factor Authentication Required'**
  String get mfaRequired;

  /// No description provided for @authenticationError.
  ///
  /// In en, this message translates to:
  /// **'Authentication Error'**
  String get authenticationError;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get validationError;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get serverError;

  /// No description provided for @invalidCredentialsMessage.
  ///
  /// In en, this message translates to:
  /// **'The email or password you entered is incorrect. Please try again.'**
  String get invalidCredentialsMessage;

  /// No description provided for @accountDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account has been disabled. Please contact support for assistance.'**
  String get accountDisabledMessage;

  /// No description provided for @mfaRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'This account requires multi-factor authentication. Please enter your authentication code.'**
  String get mfaRequiredMessage;

  /// No description provided for @mfaDeviceNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No multi-factor authentication device found for this account.'**
  String get mfaDeviceNotFoundMessage;

  /// No description provided for @mfaDeviceNotConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your multi-factor authentication device is not confirmed. Please contact support.'**
  String get mfaDeviceNotConfirmedMessage;

  /// No description provided for @mfaSecretMissingMessage.
  ///
  /// In en, this message translates to:
  /// **'Multi-factor authentication is not properly configured. Please contact support.'**
  String get mfaSecretMissingMessage;

  /// No description provided for @invalidMfaCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'The authentication code you entered is invalid. Please try again.'**
  String get invalidMfaCodeMessage;

  /// No description provided for @networkErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server. Please check your internet connection and try again.'**
  String get networkErrorMessage;

  /// No description provided for @serverErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'The server is experiencing issues. Please try again later.'**
  String get serverErrorMessage;

  /// No description provided for @enterMfaCode.
  ///
  /// In en, this message translates to:
  /// **'Enter MFA Code'**
  String get enterMfaCode;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @mfaDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Multi-Factor Authentication'**
  String get mfaDialogTitle;

  /// No description provided for @mfaNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'MFA functionality is not yet implemented.'**
  String get mfaNotImplemented;

  /// No description provided for @analyzeNewVideo.
  ///
  /// In en, this message translates to:
  /// **'Analyze new video'**
  String get analyzeNewVideo;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
