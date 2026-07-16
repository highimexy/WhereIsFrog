import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:where_is_frog/data/models/beer.dart';
import 'package:where_is_frog/theme/app_theme.dart';
import 'drink_tracker.dart';

class BeerDetailScreen extends StatelessWidget {
  const BeerDetailScreen({super.key, required this.beer});

  final Beer beer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(beer.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'bottle-${beer.id}',
              child: bottleArtForDetail(beer),
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: DrinkTracker.instance,
              builder: (context, _) {
                if (DrinkTracker.instance.countFor(beer.id) <= 0) {
                  return const SizedBox.shrink();
                }
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.brassLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.brassLight),
                  ),
                  child: Text(
                    'Wypróbowane ✅',
                    style: textTheme.labelLarge?.copyWith(color: AppColors.brassLight),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(beer.name, style: textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(
              '${beer.style} · ${beer.brewery}',
              style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ListenableBuilder(
              listenable: DrinkTracker.instance,
              builder: (context, _) {
                final count = DrinkTracker.instance.countFor(beer.id);
                return Column(
                  children: [
                    Text('Wypite razy', style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _BigStepButton(
                          icon: Icons.remove,
                          enabled: count > 0,
                          onTap: () => DrinkTracker.instance.decrement(beer.id),
                        ),
                        SizedBox(
                          width: 64,
                          child: Text(
                            '$count',
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium,
                          ),
                        ),
                        _BigStepButton(
                          icon: Icons.add,
                          enabled: true,
                          onTap: () => DrinkTracker.instance.increment(beer.id),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Stat(label: 'ABV', value: '${beer.abv}%'),
                const SizedBox(width: 24),
                if (beer.rating != null)
                  _Stat(label: 'Ocena', value: '${beer.rating} / 5'),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Dostępne w:', style: textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            ...beer.venueNames.map(
              (venue) => Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.storefront, color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(venue, style: textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/compass'),
              icon: const Icon(Icons.explore),
              label: const Text('POKAŻ NA KOMPASIE'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget bottleArtForDetail(Beer beer) {
  final asset = beer.imageAsset;
  return Container(
    width: 160,
    height: 220,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: AppColors.secondary,
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 8)),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: asset != null
        ? Image.asset(
            asset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _detailPlaceholder(context, beer),
          )
        : Builder(builder: (context) => _detailPlaceholder(context, beer)),
  );
}

Widget _detailPlaceholder(BuildContext context, Beer beer) {
  return Container(
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.accent, AppColors.secondary],
      ),
    ),
    child: const Icon(Icons.sports_bar, color: AppColors.brassLight, size: 56),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(value, style: textTheme.titleLarge),
        Text(label, style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _BigStepButton extends StatelessWidget {
  const _BigStepButton({required this.icon, required this.enabled, required this.onTap});

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: enabled ? 0.25 : 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 24,
          color: enabled ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
