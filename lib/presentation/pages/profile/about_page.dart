import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Logo placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/logo.png',
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.celebration,
                    size: 60,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.appTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
            ),
            const Text(
              'v1.0.0',
              style: TextStyle(color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Guestly es la solución definitiva para la gestión de invitados y control de acceso mediante códigos QR. Diseñada para hacer tus eventos más organizados y seguros.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionTitle(context, 'Nuestros Canales'),
            const SizedBox(height: 12),
            // Placeholders for Social Media and Website
            _buildLinkCard(
              context,
              Icons.language,
              'Sitio Web',
              'www.tusitio.com',
              () {
                // TODO: Implement website launch
              },
            ),
            _buildLinkCard(
              context,
              Icons.camera_alt_outlined,
              'Instagram',
              '@tu_usuario',
              () {
                // TODO: Implement instagram launch
              },
            ),
            _buildLinkCard(
              context,
              Icons.facebook_outlined,
              'Facebook',
              'facebook.com/pag',
              () {
                // TODO: Implement facebook launch
              },
            ),
            const SizedBox(height: 40),
            const Text(
              '© 2026 Guestly Team. Todos los derechos reservados.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryNavy,
      ),
    );
  }

  Widget _buildLinkCard(BuildContext context, IconData icon, String label,
      String value, VoidCallback onTap) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: AppColors.surfaceVariantLight,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryNavy),
        title: Text(label),
        subtitle: Text(value, style: const TextStyle(color: AppColors.secondaryTeal)),
        trailing: const Icon(Icons.open_in_new, size: 16),
        onTap: onTap,
      ),
    );
  }
}
