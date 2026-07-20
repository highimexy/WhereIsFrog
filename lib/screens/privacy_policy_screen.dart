import 'package:flutter/material.dart';
import 'package:where_is_frog/theme/app_theme.dart';

/// Polityka prywatności wyświetlana w aplikacji (wymóg Google Play i App Store).
///
/// TODO: to jest treść tymczasowa. Przed publikacją w sklepach zastąp adres
/// kontaktowy prawdziwym adresem e-mail/domeną i opublikuj tę samą treść
/// pod publicznym adresem URL (wymagany osobno w Play Console / App Store Connect).
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const _lastUpdated = '20.07.2026';
  static const _contactEmail = 'kontakt@fewbears.app';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Polityka prywatności')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Ostatnia aktualizacja: $_lastUpdated', style: textTheme.bodySmall),
            const SizedBox(height: 20),
            _Section(
              title: 'Jakie dane zbieramy',
              body:
                  'Few Bears prosi o dostęp do Twojej lokalizacji (GPS), żeby wskazać '
                  'kompasem najbliższy sklep sprzedający alkohol. Lokalizacja jest '
                  'używana wyłącznie w momencie wyszukiwania i nie jest zapisywana '
                  'na naszych serwerach — bo takich serwerów po prostu nie mamy.',
            ),
            _Section(
              title: 'Udostępnianie danych stronom trzecim',
              body:
                  'Aby znaleźć pobliskie sklepy, Twoje współrzędne GPS są wysyłane do '
                  'darmowego, publicznego serwisu Overpass API, opartego na danych '
                  'OpenStreetMap (overpass-api.de). To jedyny zewnętrzny serwis, do '
                  'którego trafiają Twoje dane lokalizacyjne. Nie korzystamy z reklam, '
                  'analityki ani śledzenia użytkowników.',
            ),
            _Section(
              title: 'Co zapisujemy lokalnie na Twoim telefonie',
              body:
                  'Aplikacja zapisuje na Twoim urządzeniu (nie na serwerze) informację, '
                  'czy ukończyłeś/aś onboarding, potwierdzenie pełnoletności oraz listę '
                  'piw oznaczonych jako "wypróbowane" w Spiżarni. Te dane nigdy nie '
                  'opuszczają Twojego telefonu i znikają po odinstalowaniu aplikacji.',
            ),
            _Section(
              title: 'Konta użytkowników',
              body:
                  'Few Bears nie wymaga zakładania konta ani logowania — nie zbieramy '
                  'imienia, adresu e-mail ani innych danych identyfikujących.',
            ),
            _Section(
              title: 'Twoje prawa',
              body:
                  'W każdej chwili możesz cofnąć dostęp do lokalizacji w ustawieniach '
                  'systemowych telefonu oraz usunąć wszystkie lokalne dane, odinstalowując '
                  'aplikację.',
            ),
            _Section(
              title: 'Kontakt',
              body: 'Pytania dotyczące prywatności możesz kierować na $_contactEmail.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.titleMedium?.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(body, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
