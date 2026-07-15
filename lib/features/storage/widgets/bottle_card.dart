import 'package:flutter/material.dart';
import 'package:where_is_frog/data/models/beer.dart';
import 'package:where_is_frog/theme/app_theme.dart';

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
              child: _BottleArt(beer: beer, height: 150),
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
          ],
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
