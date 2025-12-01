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
  String get tapATeamMember => 'Tap a team member to learn more';

  @override
  String get contact => 'Contact';

  @override
  String get simulation => 'Simulation';

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
  String get fileSelection => 'File selection';

  @override
  String selectedFile(String fileName) {
    return 'Selected: $fileName';
  }

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get enterTitle => 'Enter title';

  @override
  String get enterDescription => 'Enter description';

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

  @override
  String get signInFailed => 'Sign In Failed';

  @override
  String get accountDisabled => 'Account Disabled';

  @override
  String get mfaRequired => 'Multi-Factor Authentication Required';

  @override
  String get authenticationError => 'Authentication Error';

  @override
  String get validationError => 'Validation Error';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get serverError => 'Server Error';

  @override
  String get invalidCredentialsMessage =>
      'The email or password you entered is incorrect. Please try again.';

  @override
  String get accountDisabledMessage =>
      'Your account has been disabled. Please contact support for assistance.';

  @override
  String get mfaRequiredMessage =>
      'This account requires multi-factor authentication. Please enter your authentication code.';

  @override
  String get mfaDeviceNotFoundMessage =>
      'No multi-factor authentication device found for this account.';

  @override
  String get mfaDeviceNotConfirmedMessage =>
      'Your multi-factor authentication device is not confirmed. Please contact support.';

  @override
  String get mfaSecretMissingMessage =>
      'Multi-factor authentication is not properly configured. Please contact support.';

  @override
  String get invalidMfaCodeMessage =>
      'The authentication code you entered is invalid. Please try again.';

  @override
  String get networkErrorMessage =>
      'Unable to connect to the server. Please check your internet connection and try again.';

  @override
  String get serverErrorMessage =>
      'The server is experiencing issues. Please try again later.';

  @override
  String get enterMfaCode => 'Enter MFA Code';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get mfaDialogTitle => 'Multi-Factor Authentication';

  @override
  String get mfaNotImplemented => 'MFA functionality is not yet implemented.';

  @override
  String get analyzeNewVideo => 'Analyze new video';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get noAnalysesFound => 'No analyses found.';

  @override
  String get analyses => 'Analyses';

  @override
  String get loadingAnalysesError =>
      'An error occurred while loading analyses.';

  @override
  String get addYourFirstAnalysis =>
      'Add your first analysis by uploading a video.';

  @override
  String get createAnalysis => 'Create analysis';

  @override
  String get clickToUpload => 'Click to upload a video';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get search => 'Search';

  @override
  String get apply => 'Apply';

  @override
  String get close => 'Close';

  @override
  String get reset => 'Reset';

  @override
  String get createdAt => 'Created at';

  @override
  String get title => 'Title';

  @override
  String get ascending => 'Ascending';

  @override
  String get descending => 'Descending';

  @override
  String get mostConfidentResult => 'Most confident result';

  @override
  String get allResults => 'All results';

  @override
  String get notSet => 'Not set';

  @override
  String get status => 'Status';

  @override
  String get analysisDetails => 'Analysis details';

  @override
  String get confidence => 'Confidence';

  @override
  String get substance => 'Substance';

  @override
  String get description => 'Description';

  @override
  String detectedSubstances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Detected substances',
      one: 'Detected substance',
      zero: 'No detected substances',
    );
    return '$_temp0';
  }

  @override
  String get analysis => 'Analysis';

  @override
  String get date => 'Date';

  @override
  String get datesRange => 'Dates range';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get cancelUpload => 'Cancel upload';

  @override
  String get cancelFileUpload => 'Cancel file upload';

  @override
  String get loadingFile => 'Loading file';

  @override
  String get back => 'Back';

  @override
  String get confirmDelete => 'Confirm delete';

  @override
  String get confirm => 'Confirm';

  @override
  String confirmDeleteAnalysisText(String title) {
    return 'Are you sure you want to delete $title? This action can\'t be undone.';
  }

  @override
  String get delete => 'Delete';

  @override
  String get export => 'Export';

  @override
  String maximumFileSize(String size) {
    return 'Maximum file size is $size';
  }

  @override
  String get fileSizeError =>
      'This file is too big! Please select another one.';

  @override
  String get success => 'Success';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get restart => 'Restart';

  @override
  String get toggleUI => 'Toggle UI';

  @override
  String get simulationDescription =>
      'Interactive simulation powered by Unity.';

  @override
  String get simulation_how_to_1 =>
      'Use the controls above the simulation to manage the simulation - pause, resume, restart and toggle UI.';

  @override
  String get simulation_how_to_2 =>
      'Use the controls inside the simulation to change larva state or simulation speed.';

  @override
  String get simulation_how_to_3 =>
      'In the right panel, you can select which substance you want to give to the poor larva, and specify the intensity.';

  @override
  String get notFound_title => 'Page Not Found';

  @override
  String get notFound_description =>
      'The page you\'re looking for doesn\'t exist or was moved.';

  @override
  String get viewResults => 'View results';

  @override
  String get optional => 'Optional';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get patient => 'Patient';

  @override
  String get selectedPatient => 'Selected patient';

  @override
  String get patientSearchDescription =>
      'Associate patient with the analysis. Search them with PESEL or name.';

  @override
  String get peselMustBe11Digits => 'PESEL must contain exactly 11 digits';

  @override
  String get invalidPeselNumber => 'Invalid PESEL number';

  @override
  String get patientsNotFound => 'Patients not found';

  @override
  String get fullName => 'Full name';

  @override
  String get name => 'Name';

  @override
  String get birthDate => 'Birth date';

  @override
  String get gender => 'Gender';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Address';

  @override
  String get city => 'City';

  @override
  String get postalCode => 'Postal code';

  @override
  String get country => 'Country';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';
}
