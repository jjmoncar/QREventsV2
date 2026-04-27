import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_theme.dart';
import 'core/router/app_router.dart';
import 'injection.dart';
import 'l10n/app_localizations.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/events/events_bloc.dart';
import 'presentation/blocs/guests/guests_bloc.dart';
import 'presentation/blocs/scanner/scanner_bloc.dart';
import 'presentation/blocs/settings/settings_cubit.dart';
import 'presentation/blocs/settings/settings_state.dart';

class GuestlyApp extends StatelessWidget {
  const GuestlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(AuthCheckSession())),
        BlocProvider(create: (_) => sl<EventsBloc>()),
        BlocProvider(create: (_) => sl<GuestsBloc>()),
        BlocProvider(create: (_) => sl<ScannerBloc>()),
        BlocProvider(create: (_) => sl<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'Guestly',
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            locale: settings.locale,
            routerConfig: appRouter,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
