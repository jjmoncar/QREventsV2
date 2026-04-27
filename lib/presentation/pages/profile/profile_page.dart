import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.profile)),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = state.user;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 52,
                  backgroundColor:
                      AppColors.primaryNavy.withValues(alpha: 0.1),
                  child: Text(
                    user.name?.isNotEmpty == true
                        ? user.name![0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name ?? AppLocalizations.of(context)!.user,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: user.isAdmin
                        ? AppColors.primaryNavy.withValues(alpha: 0.1)
                        : AppColors.secondaryTeal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    user.isAdmin ? AppLocalizations.of(context)!.admin : AppLocalizations.of(context)!.staff,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: user.isAdmin
                          ? AppColors.primaryNavy
                          : AppColors.secondaryTeal,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _menuItem(context, Icons.bar_chart,
                    AppLocalizations.of(context)!.analytics, () {
                  context.push('/analytics');
                }),
                _menuItem(context, Icons.help_outline,
                    AppLocalizations.of(context)!.help, () {
                  context.push('/help');
                }),
                _menuItem(context, Icons.info_outline,
                    AppLocalizations.of(context)!.about, () {
                  context.push('/about');
                }),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    },
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: Text(
                      AppLocalizations.of(context)!.logout,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _menuItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryNavy),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right,
          color: AppColors.textSecondaryLight),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
    );
  }
}
