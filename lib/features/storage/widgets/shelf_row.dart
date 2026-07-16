import 'package:flutter/material.dart';
import 'package:where_is_frog/data/models/beer.dart';
import 'package:where_is_frog/theme/app_theme.dart';
import 'package:where_is_frog/widgets/staggered_reveal.dart';
import 'bottle_card.dart';

/// Pozioma "półka" piw jednego stylu, z ciepłym światłem z góry.
class ShelfRow extends StatelessWidget {
  const ShelfRow({
    super.key,
    required this.style,
    required this.beers,
    required this.onBeerTap,
  });

  final String style;
  final List<Beer> beers;
  final ValueChanged<Beer> onBeerTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(style, style: Theme.of(context).textTheme.titleLarge),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(18),
              border: Border(
                top: BorderSide(color: AppColors.brassLight.withValues(alpha: 0.25), width: 3),
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: beers.length,
                itemBuilder: (context, index) {
                  final beer = beers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: StaggeredReveal(
                      index: index,
                      child: BottleCard(beer: beer, onTap: () => onBeerTap(beer)),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
