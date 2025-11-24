# Polityka Prywatności

**Data wejścia w życie:** TBD  
**Ostatnia aktualizacja:** TBD

## 1. Wprowadzenie

Larvixon („my", „nasz") prowadzi platformę internetową do wspomaganego AI wykrywania 
toksyn poprzez analizę wideo larw. Niniejsza Polityka Prywatności wyjaśnia, jak 
zbieramy, wykorzystujemy, przechowujemy i chronimy Twoje dane osobowe.

**Administrator danych:**
- Organizacja: TBD
- Adres: TBD
- Email: TBD
- IOD (Inspektor Ochrony Danych): TBD

---

## 2. Jakie Dane Zbieramy

### 2.1 Dane Konta (Dane Osobowe)
Podczas rejestracji zbieramy:
- **Adres email** (używany do logowania i komunikacji)
- **Hasło** (hashowane przy użyciu Argon2, nigdy nie przechowywane w postaci jawnej)
- **Imię i nazwisko**
- **Organizacja** (opcjonalnie, np. szpital, instytut badawczy)
- **Bio/Opis** (opcjonalnie)

**Podstawa prawna:** Niezbędność umowna (RODO Art. 6(1)(b))

### 2.2 Dane Medyczne (Szczególne Kategorie Danych według RODO)
Podczas przesyłania analizy zbieramy:
- **Pliki wideo** larw wystawionych na osocze pacjenta
- **Metadane analizy:** data przesłania, nazwa, status
- **Wyniki AI:** wykryte substancje, współczynniki pewności

⚠️ **Ważne:** Nagrania mogą pośrednio zawierać dane zdrowotne pacjentów (poprzez 
ekspozycję na osocze). NIE zbieramy bezpośrednich identyfikatorów pacjenta (imię, 
numer PESEL, numer dokumentacji medycznej).

**Podstawa prawna:** 
- Wyraźna zgoda (RODO Art. 9(2)(a))
- Cele badań naukowych (RODO Art. 9(2)(j)) jeśli dotyczy

### 2.3 Dane Techniczne (Zbierane Automatycznie)
- **Adres IP** (dla bezpieczeństwa, limitowania żądań)
- **Typ i wersja przeglądarki**
- **Informacje o urządzeniu** (OS, rozmiar ekranu)
- **Pliki cookie i tokeny sesji** (JWT do uwierzytelniania)
- **Logi żądań API** (timestamp, endpoint, kod statusu)

**Podstawa prawna:** Prawnie uzasadniony interes (RODO Art. 6(1)(f))

---

## 3. Jak Wykorzystujemy Twoje Dane

### 3.1 Główne Cele
- **Świadczenie usługi:** Przetwarzanie wideo, analiza AI, wyświetlanie wyników
- **Zarządzanie kontem:** Uwierzytelnianie, aktualizacje profilu
- **Komunikacja:** Powiadomienia o zakończeniu analizy, ważne informacje
- **Wsparcie:** Odpowiedzi na zapytania i problemy techniczne

### 3.2 NIE:
- ❌ Sprzedajemy danych osobom trzecim
- ❌ Wykorzystujemy danych pacjentów do celów innych niż analiza
- ❌ Udostępniamy danych medycznych bez wyraźnej zgody
- ❌ Trenujemy modeli AI na danych z możliwością identyfikacji

---

## 4. Przechowywanie i Bezpieczeństwo Danych

### 4.1 Gdzie Przechowujemy Dane
- **Serwery:** Centra danych w UE (zgodne z RODO)
- **Baza danych:** Szyfrowanie w spoczynku (AES-256)
- **Pliki wideo:** Szyfrowanie po stronie serwera

### 4.2 Środki Bezpieczeństwa
- ✅ **Szyfrowanie w tranzycie:** TLS 1.3 (HTTPS)
- ✅ **Szyfrowanie w spoczynku:** AES-256
- ✅ **Hashowanie haseł:** Argon2 z unikalną solą
- ✅ **Kontrola dostępu:** RBAC (kontrola dostępu oparta na rolach)
- ✅ **Uwierzytelnianie:** Tokeny JWT z 24-godzinnym wygaśnięciem
- ✅ **Limitowanie żądań:** Maksymalnie 100 żądań/minutę
- ✅ **Regularne kopie zapasowe:** TBD

### 4.3 Retencja Danych
- **Dane konta:** Przechowywane podczas aktywności konta + 30 dni po usunięciu
- **Pliki wideo:** Przechowywane przez **TBD**, potem automatycznie usuwane
- **Wyniki analiz:** Przechowywane przez **TBD**, potem anonimizowane
- **Logi:** Przechowywane przez **TBD**

---

## 5. Udostępnianie Danych

### 5.1 Udostępniamy Dane:
- **Hosting w chmurze:** Azure (na podstawie DPA zgodnego z RODO)
- **Usługa email:** Tylko emaile transakcyjne

### 5.2 NIE Udostępniamy:
- ❌ Firmom marketingowym
- ❌ Platformom społecznościowym
- ❌ Firmom ubezpieczeniowym
- ❌ Osobom trzecim bez Twojej wyraźnej zgody

---

## 6. Twoje Prawa według RODO

### 6.1 Prawo Dostępu (Art. 15)
Zażądaj kopii wszystkich danych, które o Tobie posiadamy.

### 6.2 Prawo do Sprostowania (Art. 16)
Popraw nieprawidłowe lub niekompletne dane.

### 6.3 Prawo do Usunięcia („Prawo do Bycia Zapomnianym") (Art. 17)
Zażądaj usunięcia swojego konta i wszystkich powiązanych danych.

### 6.4 Prawo do Przenoszenia Danych (Art. 20)
Otrzymaj swoje dane w formacie umożliwiającym odczyt maszynowy (JSON/CSV).

### 6.5 Prawo do Sprzeciwu (Art. 21)
Sprzeciw wobec przetwarzania na podstawie prawnie uzasadnionego interesu.

### 6.6 Prawo do Złożenia Skargi
Złóż skargę do krajowego organu ochrony danych.  
**Polska:** UODO (Urząd Ochrony Danych Osobowych) - uodo.gov.pl

**Jak skorzystać z praw:** Skontaktuj się TBD

---

## 7. Pliki Cookie

### 7.1 Niezbędne Pliki Cookie
- **Token uwierzytelniający (JWT):** Utrzymuje zalogowanie (24h wygaśnięcie)

---

## 8. Prywatność Dzieci

LarvixON jest przeznaczony dla **profesjonalistów medycznych i naukowców (18+)**.

NIE zbieramy świadomie danych od dzieci poniżej 16 roku życia.

---

## 9. Zmiany w Polityce Prywatności

Poinformujemy Cię o istotnych zmianach przez email i banner w aplikacji.

---

## 10. Dane Kontaktowe

**Inspektor Ochrony Danych (IOD):**  
Email: TBD
Adres: TBD

**Ogólne Zapytania:**  
Email: TBD