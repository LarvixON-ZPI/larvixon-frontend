// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get password => 'Hasło';

  @override
  String get email => 'Email';

  @override
  String get firstName => 'Imię';

  @override
  String get lastName => 'Nazwisko';

  @override
  String get fieldIsRequired => 'To pole jest wymagane';

  @override
  String get invalidEmailFormat => 'Nieprawidłowy format adresu email';

  @override
  String passwordIsTooShort(int length) {
    return 'Hasło powinno mieć co najmniej $length znaków';
  }

  @override
  String get passwordsDoNotMatch => 'Hasła nie pasują do siebie';

  @override
  String get confirmPassword => 'Potwierdź hasło';

  @override
  String get username => 'Nazwa użytkownika';

  @override
  String get signUp => 'Zarejestruj się';

  @override
  String get signIn => 'Zaloguj się';
}
