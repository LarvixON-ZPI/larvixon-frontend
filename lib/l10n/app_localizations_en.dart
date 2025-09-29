// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get password => 'Password';

  @override
  String get email => 'Email';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get fieldIsRequired => 'This field is required';

  @override
  String get invalidEmailFormat => 'Invalid email format';

  @override
  String bioIsTooLong(int length) {
    return 'Bio should not exceed $length characters';
  }

  @override
  String organizationIsTooLong(int length) {
    return 'Organization name should not exceed $length characters';
  }

  @override
  String fieldIsTooLong(String field, int length) {
    return '$field should not exceed $length characters';
  }

  @override
  String fieldIsTooShort(String field, int length) {
    return '$field should be at least $length characters long';
  }

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String passwordIsTooShort(int length) {
    return 'Password should be at least $length characters long';
  }

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get username => 'Username';

  @override
  String get signUp => 'Sign up';

  @override
  String get signIn => 'Sign in';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get organization => 'Organization';

  @override
  String get bio => 'Bio';

  @override
  String get account => 'Account';

  @override
  String get save => 'Save';

  @override
  String get logout => 'Log out';

  @override
  String welcome(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get getStarted => 'Get Started';

  @override
  String get larvixon => 'Larvixon';

  @override
  String get about => 'About';

  @override
  String get contact => 'Contact';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get larvixonHeader => 'ML-Powered Diagnostics in Minutes';

  @override
  String get larvixonSubheader =>
      'A breakthrough system for rapid detection of toxins and drugs.';

  @override
  String get larvixonDescription =>
      'Our platform uses artificial intelligence to analyze subtle movement patterns of various larvae exposed to patient plasma. In less than 20 minutes, it delivers highly accurate insights into the presence of xenobiotics — helping doctors act faster, save lives, and improve treatment outcomes.';

  @override
  String get privacy => 'Privacy';

  @override
  String get terms => 'Terms';

  @override
  String get follow => 'Follow';

  @override
  String get reachUs => 'Reach us';

  @override
  String get sendUsAMessage => 'Send us a message';

  @override
  String get send => 'Send';

  @override
  String get message => 'Message';

  @override
  String get aboutDescription =>
      'We are a team of passionate developers building modern, responsive apps. Our goal is to deliver high-quality products and collaborate effectively with our stakeholders.';

  @override
  String get ourMission => 'Our Mission';

  @override
  String get ourMissionDescription =>
      'To build apps that make life easier for medical staff by providing useful tooling.';

  @override
  String get ourVision => 'Our Vision';

  @override
  String get ourVisionDescription =>
      'To innovate continuously and provide seamless digital experiences.';

  @override
  String get ourTeam => 'Our Team';

  @override
  String get messageSentAcknowledgment => 'Message sent — thank you!';

  @override
  String get contactDescription =>
      'Have a question or want to collaborate? Drop us a message.';

  @override
  String get uploadNewVideo => 'Upload new video';

  @override
  String get uploadVideoDescription =>
      'Upload a new video to the platform to analyze larval movements.';

  @override
  String get cancel => 'Cancel';

  @override
  String get upload => 'Upload';

  @override
  String get selectVideo => 'Select Video';

  @override
  String selectedFile(String fileName) {
    return 'Selected: $fileName';
  }

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get enterTitle => 'Enter title';

  @override
  String get uploading => 'Uploading';

  @override
  String get uploaded => 'Uploaded';

  @override
  String get pending => 'Pending';

  @override
  String get processing => 'Processing';

  @override
  String get completed => 'Completed';

  @override
  String get failed => 'Failed';

  @override
  String get analysing => 'Analysing';

  @override
  String get analysed => 'Analysed';

  @override
  String get error => 'Error';

  @override
  String andMore(int count) {
    return '$count more';
  }

  @override
  String get loading => 'Loading';

  @override
  String get retry => 'Retry';
}
