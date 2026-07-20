import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:where_is_frog/data/models/beer.dart';
import 'package:where_is_frog/data/repositories/beer_repository.dart';
import 'package:where_is_frog/theme/app_theme.dart';
import 'drink_tracker.dart';
import 'widgets/shelf_row.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  final BeerRepository _repository = const MockBeerRepository();
  late final Future<List<Beer>> _beersFuture = _loadAll();
  final _searchController = TextEditingController();
  String _query = '';

  Future<List<Beer>> _loadAll() async {
    final results = await Future.wait([
      _repository.nearbyBeers(),
      DrinkTracker.instance.ensureLoaded(),
    ]);
    return results[0] as List<Beer>;
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spiżarnia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Polityka prywatności',
            onPressed: () => context.push('/privacy-policy'),
          ),
        ],
      ),
      body: FutureBuilder<List<Beer>>(
        future: _beersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allBeers = snapshot.data!;
          final query = _query;
          final filtered = query.isEmpty
              ? allBeers
              : allBeers.where((beer) {
                  return beer.name.toLowerCase().contains(query) ||
                      beer.style.toLowerCase().contains(query) ||
                      beer.brewery.toLowerCase().contains(query);
                }).toList();

          final beersByStyle = <String, List<Beer>>{};
          for (final beer in filtered) {
            beersByStyle.putIfAbsent(beer.style, () => []).add(beer);
          }

          return ListenableBuilder(
            listenable: DrinkTracker.instance,
            builder: (context, _) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _ChallengeProgress(total: allBeers.length),
                  ),
                  SliverToBoxAdapter(child: _SearchField(controller: _searchController)),
                  SliverToBoxAdapter(child: _FilterBar()),
                  if (filtered.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'Brak piw pasujących do szukanej frazy.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )
                  else
                    SliverList.list(
                      children: beersByStyle.entries
                          .map((entry) => ShelfRow(
                                style: entry.key,
                                beers: entry.value,
                                onBeerTap: (beer) =>
                                    context.push('/storage/beer/${beer.id}', extra: beer),
                              ))
                          .toList(),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _ChallengeProgress extends StatelessWidget {
  const _ChallengeProgress({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final tried = DrinkTracker.instance.triedCount;
    final progress = total == 0 ? 0.0 : tried / total;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Wypróbowano $tried/$total piw', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.4),
              valueColor: const AlwaysStoppedAnimation(AppColors.brassLight),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: TextField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Szukaj piwa, stylu, browaru...',
          hintStyle: TextStyle(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: controller.clear,
                ),
          filled: true,
          fillColor: AppColors.roughCard,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
          ),
        ),
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
