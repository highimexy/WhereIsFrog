import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:where_is_frog/data/models/beer.dart';
import 'package:where_is_frog/data/repositories/beer_repository.dart';
import 'package:where_is_frog/theme/app_theme.dart';
import 'widgets/shelf_row.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  final BeerRepository _repository = const MockBeerRepository();
  late final Future<List<Beer>> _beersFuture = _repository.nearbyBeers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spiżarnia')),
      body: FutureBuilder<List<Beer>>(
        future: _beersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final beersByStyle = <String, List<Beer>>{};
          for (final beer in snapshot.data!) {
            beersByStyle.putIfAbsent(beer.style, () => []).add(beer);
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _FilterBar()),
              SliverList.list(
                children: beersByStyle.entries
                    .map((entry) => ShelfRow(
                          style: entry.key,
                          beers: entry.value,
                          onBeerTap: (beer) => context.push('/storage/beer/${beer.id}', extra: beer),
                        ))
                    .toList(),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          _FilterChip(label: 'W pobliżu'),
          const SizedBox(width: 10),
          _FilterChip(label: 'Styl'),
          const SizedBox(width: 10),
          _FilterChip(label: 'Cena'),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.roughCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, color: AppColors.primary, size: 18),
        ],
      ),
    );
  }
}
