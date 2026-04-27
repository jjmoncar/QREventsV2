import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_theme.dart';
import '../../blocs/settings/settings_cubit.dart';
import '../../blocs/settings/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        return Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
          body: ListView(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            children: [
              // Theme Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.appearance,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: Text(AppLocalizations.of(context)!.dark_mode),
                      subtitle: Text(
                        settings.themeMode == ThemeMode.dark
                            ? AppLocalizations.of(context)!.enabled
                            : AppLocalizations.of(context)!.disabled,
                      ),
                      value: settings.themeMode == ThemeMode.dark,
                      onChanged: (_) {
                        context.read<SettingsCubit>().toggleTheme();
                      },
                      activeTrackColor: AppColors.secondaryTeal,
                      secondary: Icon(
                        settings.themeMode == ThemeMode.dark
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Language
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.language,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    _languageTile(
                      context,
                      'Español',
                      '🇪🇸',
                      settings.locale.languageCode == 'es',
                      const Locale('es'),
                    ),
                    _languageTile(
                      context,
                      'English',
                      '🇺🇸',
                      settings.locale.languageCode == 'en',
                      const Locale('en'),
                    ),
                    _languageTile(
                      context,
                      'Português',
                      '🇧🇷',
                      settings.locale.languageCode == 'pt',
                      const Locale('pt'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // About
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.info,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(Icons.info_outline,
                          color: AppColors.primaryNavy),
                      title: Text(AppLocalizations.of(context)!.version),
                      trailing: const Text('1.0.0',
                          style:
                              TextStyle(color: AppColors.textSecondaryLight)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.description_outlined,
                          color: AppColors.primaryNavy),
                      title: Text(AppLocalizations.of(context)!.termsOfUse),
                      trailing: const Icon(Icons.open_in_new, size: 18),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined,
                          color: AppColors.primaryNavy),
                      title: Text(AppLocalizations.of(context)!.privacyPolicy),
                      trailing: const Icon(Icons.open_in_new, size: 18),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _languageTile(BuildContext context, String name, String flag,
      bool selected, Locale locale) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(name),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.secondaryTeal)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () {
        context.read<SettingsCubit>().setLocale(locale);
      },
    );
  }
}
