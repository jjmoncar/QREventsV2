import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const _routes = ['/dashboard', '/events', '/profile', '/settings'];

  @override
  Widget build(BuildContext context) {
    // Sync index with current route
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) {
        _currentIndex = i;
        break;
      }
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
              context.go(_routes[index]);
            },
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor:
                AppColors.secondaryTeal.withValues(alpha: 0.15),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard,
                    color: AppColors.secondaryTeal),
                label: AppLocalizations.of(context)!.dashboard,
              ),
              NavigationDestination(
                icon: Icon(Icons.event_outlined),
                selectedIcon:
                    const Icon(Icons.event, color: AppColors.secondaryTeal),
                label: AppLocalizations.of(context)!.events,
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon:
                    const Icon(Icons.person, color: AppColors.secondaryTeal),
                label: AppLocalizations.of(context)!.profile,
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon:
                    const Icon(Icons.settings, color: AppColors.secondaryTeal),
                label: AppLocalizations.of(context)!.settings,
              ),
            ],
          ),
        ),
      ),

    );
  }
}
