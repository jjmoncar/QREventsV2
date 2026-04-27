import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/event.dart';
import '../../domain/entities/guest.dart';

import 'router_refresh_stream.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/events/events_list_page.dart';
import '../../presentation/pages/events/create_event_page.dart';
import '../../presentation/pages/events/event_detail_page.dart';
import '../../presentation/pages/guests/guest_list_page.dart';
import '../../presentation/pages/guests/add_guest_page.dart';
import '../../presentation/pages/scanner/scanner_page.dart';
import '../../presentation/pages/analytics/analytics_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../../presentation/pages/profile/help_page.dart';
import '../../presentation/pages/profile/about_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  ),
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isAuthRoute = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (session == null && !isAuthRoute) {
      return '/login';
    }
    if (session != null && isAuthRoute) {
      return '/dashboard';
    }
    return null;
  },
  routes: [
    // ─── Auth Routes ───
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    // ─── Main Shell (Bottom Navigation) ───
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => HomePage(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardPage(),
          ),
        ),
        GoRoute(
          path: '/events',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: EventsListPage(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfilePage(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsPage(),
          ),
        ),
      ],
    ),

    // ─── Full-Screen Routes ───
    GoRoute(
      path: '/events/create',
      builder: (context, state) =>
          CreateEventPage(event: state.extra as EventEntity?),
    ),
    GoRoute(
      path: '/events/:id',
      builder: (context, state) => EventDetailPage(
        eventId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/events/:id/guests',
      builder: (context, state) => GuestListPage(
        eventId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/events/:id/guests/add',
      builder: (context, state) => AddGuestPage(
        eventId: state.pathParameters['id']!,
        guest: state.extra as GuestEntity?,
      ),
    ),
    GoRoute(
      path: '/events/:id/scanner',
      builder: (context, state) => ScannerPage(
        eventId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const AnalyticsPage(),
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => const HelpPage(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutPage(),
    ),
  ],
);
