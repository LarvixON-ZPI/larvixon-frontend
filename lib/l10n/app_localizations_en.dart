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
}
