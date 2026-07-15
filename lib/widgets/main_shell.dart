import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:where_is_frog/widgets/brass_bottom_nav.dart';

/// Kontener zakładek (Kompas / Spiżarnia) na bazie [StatefulNavigationShell].
///
/// Przy zmianie taba robimy poziomy slide/push (zamiast cross-fade) —
/// [StatefulNavigationShell] trzyma oba branche żywe w jednym IndexedStack,
/// więc stan każdej zakładki (np. wynik wyszukiwania kompasu) jest zachowany
/// między przełączeniami.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with SingleTickerProviderStateMixin {
  late final AnimationController _slideController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
    value: 1, // W pełni "dojechane" domyślnie — animujemy tylko przy zmianie taba.
  );
  late final Animation<double> _slide = CurvedAnimation(
    parent: _slideController,
    curve: Curves.easeOutCubic,
  );

  int _direction = 1;

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    final current = widget.navigationShell.currentIndex;
    if (index == current) return;
    _direction = index > current ? 1 : -1;
    _slideController.forward(from: 0);
    widget.navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      extendBody: true,
      body: AnimatedBuilder(
        animation: _slide,
        builder: (context, child) {
          final t = _slide.value;
          return Opacity(
            opacity: 0.4 + 0.6 * t,
            child: Transform.translate(
              offset: Offset((1 - t) * _direction * width * 0.3, 0),
              child: child,
            ),
          );
        },
        child: widget.navigationShell,
      ),
      bottomNavigationBar: BrassBottomNav(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
