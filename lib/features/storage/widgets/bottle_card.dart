import 'package:flutter/material.dart';
import 'package:where_is_frog/data/models/beer.dart';
import 'package:where_is_frog/theme/app_theme.dart';
import 'package:where_is_frog/features/storage/drink_tracker.dart';

class BottleCard extends StatelessWidget {
  const BottleCard({super.key, required this.beer, required this.onTap});

  final Beer beer;
  final VoidCallback onTap;

  String get _heroTag => 'bottle-${beer.id}';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: _heroTag,
              child: Stack(
                children: [
                  _BottleArt(beer: beer, height: 150),
                  ListenableBuilder(
                    listenable: DrinkTracker.instance,
                    builder: (context, _) {
                      if (DrinkTracker.instance.countFor(beer.id) <= 0) {
                        return const SizedBox.shrink();
                      }
                      return Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.brassLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: AppColors.textOnLight, size: 14),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              beer.name,
              style: textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              beer.style,
              style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            _CompactStepper(beerId: beer.id),
          ],
        ),
      ),
    );
  }
}

class _CompactStepper extends StatelessWidget {
  const _CompactStepper({required this.beerId});

  final String beerId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {}, // pochłania tap, żeby nie odpalał nawigacji karty
      child: ListenableBuilder(
        listenable: DrinkTracker.instance,
        builder: (context, _) {
          final count = DrinkTracker.instance.countFor(beerId);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepButton(
                icon: Icons.remove,
                enabled: count > 0,
                onTap: () => DrinkTracker.instance.decrement(beerId),
              ),
              SizedBox(
                width: 28,
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              _StepButton(
                icon: Icons.add,
                enabled: true,
                onTap: () => DrinkTracker.instance.increment(beerId),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.enabled, required this.onTap});

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: enabled ? 0.25 : 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 14,
          color: enabled ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _BottleArt extends StatelessWidget {
  const _BottleArt({required this.beer, required this.height});

  final Beer beer;
  final double height;

  @override
  Widget build(BuildContext context) {
    final asset = beer.imageAsset;

    return Container(
      width: 110,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: asset != null
          ? Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _placeholder(context),
            )
          : _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.accent, AppColors.secondary],
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sports_bar, color: AppColors.brassLight, size: 28),
          const SizedBox(height: 6),
          Text(
            beer.name,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
