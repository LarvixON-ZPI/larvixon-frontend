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
  String bioIsTooLong(int length) {
    return 'Bio nie powinno przekraczać $length znaków';
  }

  @override
  String organizationIsTooLong(int length) {
    return 'Nazwa organizacji nie powinna przekraczać $length znaków';
  }

  @override
  String get invalidPhoneNumber => 'Nieprawidłowy numer telefonu';

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

  @override
  String get phoneNumber => 'Numer telefonu';

  @override
  String get organization => 'Organizacja';

  @override
  String get bio => 'Bio';

  @override
  String get account => 'Konto';

  @override
  String get save => 'Zapisz';

  @override
  String get logout => 'Wyloguj się';

  @override
  String welcome(String name) {
    return 'Witaj, $name!';
  }

  @override
  String get getStarted => 'Zaczynajmy';

  @override
  String get larvixon => 'Larvixon';

  @override
  String get about => 'O nas';

  @override
  String get contact => 'Kontakt';

  @override
  String get enterEmail => 'Wprowadź swój email';

  @override
  String get larvixonHeader => 'Diagnostyka wspomagana AI w kilka minut';

  @override
  String get larvixonSubheader =>
      'Przełomowy system szybkiego wykrywania toksyn i substancji odurzających.';

  @override
  String get larvixonDescription =>
      'Nasza platforma wykorzystuje sztuczną inteligencję do analizy subtelnych wzorców ruchu różnych larw wystawionych na działanie osocza pacjenta. W mniej niż 20 minut dostarcza wysoce dokładnych informacji o obecności ksenobiotyków — pomagając lekarzom działać szybciej, ratować życie i poprawiać efekty leczenia.';
}
