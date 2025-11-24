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
  String fieldIsTooLong(String field, int length) {
    return '$field nie może przekraczać $length znaków';
  }

  @override
  String fieldIsTooShort(String field, int length) {
    return '$field musi mieć co najmniej $length znaków';
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
  String get tapATeamMember =>
      'Wybierz członka zespołu, aby dowiedzieć się więcej';

  @override
  String get contact => 'Kontakt';

  @override
  String get simulation => 'Symulacja';

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

  @override
  String get privacy => 'Prywatność';

  @override
  String get terms => 'Regulamin';

  @override
  String get follow => 'Obserwuj nas';

  @override
  String get reachUs => 'Skontaktuj się z nami';

  @override
  String get sendUsAMessage => 'Wyślij nam wiadomość';

  @override
  String get send => 'Wyślij';

  @override
  String get message => 'Wiadomość';

  @override
  String get aboutDescription =>
      'Jesteśmy zespołem ambitnych deweloperów tworzących nowoczesne, responsywne aplikacje. Naszym celem jest dostarczanie wysokiej jakości produktów i efektywna współpraca z naszymi interesariuszami.';

  @override
  String get ourMission => 'Nasza misja';

  @override
  String get ourMissionDescription =>
      'Tworzymy aplikacje, które ułatwiają pracę pracownikom medycznym przez dostarczenie przydatnych narzędzi.';

  @override
  String get ourVision => 'Nasza wizja';

  @override
  String get ourVisionDescription =>
      'Ciągła innowacja i zapewnianie płynnych doświadczeń cyfrowych.';

  @override
  String get ourTeam => 'Nasz zespół';

  @override
  String get messageSentAcknowledgment =>
      'Wiadomość została wysłana — dziękujemy!';

  @override
  String get contactDescription =>
      'Masz pytanie lub chcesz współpracować? Napisz do nas wiadomość.';

  @override
  String get uploadNewVideo => 'Prześlij nowy film do analizy';

  @override
  String get uploadVideoDescription =>
      'Prześlij nowy film na platformę, aby przeanalizować ruchy larw.';

  @override
  String get cancel => 'Anuluj';

  @override
  String get upload => 'Prześlij';

  @override
  String get selectVideo => 'Wybierz film';

  @override
  String selectedFile(String fileName) {
    return 'Wybrany: $fileName';
  }

  @override
  String get unknownError => 'Wystąpił nieznany błąd';

  @override
  String get enterTitle => 'Wprowadź tytuł';

  @override
  String get uploading => 'Przesyłanie';

  @override
  String get uploaded => 'Przesłano';

  @override
  String get pending => 'Oczekujące';

  @override
  String get processing => 'Przetwarzanie';

  @override
  String get completed => 'Zakończono';

  @override
  String get failed => 'Niepowodzenie';

  @override
  String get analysing => 'Analizowanie';

  @override
  String get analysed => 'Zanalizowano';

  @override
  String get error => 'Błąd';

  @override
  String andMore(int count) {
    return '$count więcej';
  }

  @override
  String get loading => 'Ładowanie';

  @override
  String get retry => 'Ponów';

  @override
  String get signInFailed => 'Logowanie nie powiodło się';

  @override
  String get accountDisabled => 'Konto zablokowane';

  @override
  String get mfaRequired => 'Wymagana autoryzacja dwuskładnikowa';

  @override
  String get authenticationError => 'Błąd autoryzacji';

  @override
  String get validationError => 'Błąd walidacji';

  @override
  String get connectionError => 'Błąd połączenia';

  @override
  String get serverError => 'Błąd serwera';

  @override
  String get invalidCredentialsMessage =>
      'Podany email lub hasło jest nieprawidłowe. Spróbuj ponownie.';

  @override
  String get accountDisabledMessage =>
      'Twoje konto zostało zablokowane. Skontaktuj się z pomocą techniczną.';

  @override
  String get mfaRequiredMessage =>
      'To konto wymaga autoryzacji dwuskładnikowej. Wprowadź swój kod autoryzacyjny.';

  @override
  String get mfaDeviceNotFoundMessage =>
      'Nie znaleziono urządzenia autoryzacji dwuskładnikowej dla tego konta.';

  @override
  String get mfaDeviceNotConfirmedMessage =>
      'Twoje urządzenie autoryzacji dwuskładnikowej nie zostało potwierdzone. Skontaktuj się z pomocą techniczną.';

  @override
  String get mfaSecretMissingMessage =>
      'Autoryzacja dwuskładnikowa nie jest prawidłowo skonfigurowana. Skontaktuj się z pomocą techniczną.';

  @override
  String get invalidMfaCodeMessage =>
      'Wprowadzony kod autoryzacyjny jest nieprawidłowy. Spróbuj ponownie.';

  @override
  String get networkErrorMessage =>
      'Nie można połączyć się z serwerem. Sprawdź połączenie internetowe i spróbuj ponownie.';

  @override
  String get serverErrorMessage =>
      'Serwer napotyka problemy. Spróbuj ponownie później.';

  @override
  String get enterMfaCode => 'Wprowadź kod MFA';

  @override
  String get tryAgain => 'Spróbuj ponownie';

  @override
  String get mfaDialogTitle => 'Autoryzacja dwuskładnikowa';

  @override
  String get mfaNotImplemented =>
      'Funkcjonalność MFA nie jest jeszcze zaimplementowana.';

  @override
  String get analyzeNewVideo => 'Wyślij nagranie';

  @override
  String get settings => 'Ustawienia';

  @override
  String get appearance => 'Wygląd';

  @override
  String get language => 'Język';

  @override
  String get lightMode => 'Tryb jasny';

  @override
  String get darkMode => 'Tryb ciemny';

  @override
  String get systemDefault => 'Domyślny systemowy';

  @override
  String get noAnalysesFound => 'Nie znaleziono analiz.';

  @override
  String get analyses => 'Analizy';

  @override
  String get loadingAnalysesError => 'Wystąpił błąd podczas ładowania analiz.';

  @override
  String get addYourFirstAnalysis => 'Dodaj swoją pierwszą analizę.';

  @override
  String get clickToUpload => 'Kliknij, aby przesłać nagranie.';

  @override
  String get filter => 'Filtruj';

  @override
  String get sort => 'Sortuj';

  @override
  String get search => 'Szukaj';

  @override
  String get apply => 'Zastosuj';

  @override
  String get close => 'Zamknij';

  @override
  String get reset => 'Resetuj';

  @override
  String get createdAt => 'Data utworzenia';

  @override
  String get title => 'Tytuł';

  @override
  String get ascending => 'Rosnąco';

  @override
  String get descending => 'Malejąco';

  @override
  String get mostConfidentResult => 'Najpewniejszy wynik';

  @override
  String get allResults => 'Wszystkie wyniki';

  @override
  String get notSet => 'Nie ustawiono';

  @override
  String get status => 'Status';

  @override
  String get analysisDetails => 'Szczegóły analizy';

  @override
  String get confidence => 'Pewność';

  @override
  String get substance => 'Substancja';

  @override
  String get description => 'Opis';

  @override
  String detectedSubstances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wykryte substancje',
      one: 'Wykryta substancja',
      zero: 'Brak wykrytych substancji',
    );
    return '$_temp0';
  }

  @override
  String get analysis => 'Analiza';

  @override
  String get date => 'Data';

  @override
  String get datesRange => 'Zakres dat';

  @override
  String get start => 'Początek';

  @override
  String get end => 'Koniec';

  @override
  String get from => 'Od';

  @override
  String get to => 'Do';

  @override
  String get cancelUpload => 'Anuluj przesyłanie';

  @override
  String get cancelFileUpload => 'Anuluj przesyłanie pliku';

  @override
  String get loadingFile => 'Wczytywanie pliku';

  @override
  String get back => 'Powrót';

  @override
  String get confirmDelete => 'Potwierdź usunięcie';

  @override
  String get confirm => 'Potwierdź';

  @override
  String confirmDeleteAnalysisText(String title) {
    return 'Czy na pewno chcesz usunąć $title? Tej operacji nie można cofnąć.';
  }

  @override
  String get delete => 'Usuń';

  @override
  String get export => 'Eksportuj';

  @override
  String maximumFileSize(String size) {
    return 'Maksymalny rozmiar pliku to $size';
  }

  @override
  String get fileSizeError =>
      'Wybrany plik jest zbyt duży! Proszę wybrać inny plik';

  @override
  String get success => 'Sukces';

  @override
  String get pause => 'Pauza';

  @override
  String get resume => 'Wznów';

  @override
  String get restart => 'Restart';

  @override
  String get toggleUI => 'Przełącz UI';

  @override
  String get simulationDescription => 'Interaktywna symulacja oparta na Unity.';

  @override
  String get simulation_how_to_1 =>
      'Użyj kontrolek nad oknem symulacji, aby nią zarządzać - pauzuj, wznów, restartuj lub przełącz UI.';

  @override
  String get simulation_how_to_2 =>
      'Użyj kontrolek wewnątrz okna symulacji, aby zmienić stan larwy albo prędkość symulacji.';

  @override
  String get simulation_how_to_3 =>
      'W prawym panelu możesz wybrać, jaką substancję podać biednej larwie oraz określić jej intensywność.';

  @override
  String get notFound_title => 'Nie znaleziono strony';

  @override
  String get notFound_description =>
      'Strona, której szukasz, nie istnieje lub została przeniesiona.';

  @override
  String get viewResults => 'Przejdź do wyników';

  @override
  String get optional => 'Opcjonalne';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get termsOfUse => 'Warunki użytkowania';
}
