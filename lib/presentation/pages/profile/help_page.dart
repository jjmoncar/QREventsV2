import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.help),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        children: [
          _buildSectionTitle(context, 'Códigos QR'),
          _buildHelpTile(
            context,
            '¿Qué es un código QR?',
            'Es un código de barras bidimensional que contiene el pase de entrada para tus invitados. Al escanearlo, el sistema valida automáticamente el acceso.',
          ),
          _buildHelpTile(
            context,
            '¿Cómo funciona el escaneo?',
            'Utiliza la sección de escaneo en la aplicación para leer el código QR que tus invitados mostrarán en su llegada. El sistema te dirá si el acceso está permitido.',
          ),
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'Invitaciones'),
          _buildHelpTile(
            context,
            '¿Cómo envío invitaciones?',
            'En la lista de invitados de cada evento, verás un ícono de "Enviar". Esto generará un mensaje personalizado con el enlace al pase QR único del invitado.',
          ),
          _buildHelpTile(
            context,
            '¿Qué pasa si un invitado pierde su pase?',
            'Puedes volver a enviarle la invitación en cualquier momento desde la lista de invitados.',
          ),
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'Gestión de Eventos'),
          _buildHelpTile(
            context,
            '¿Puedo editar un evento?',
            'Sí, entra a los detalles del evento y toca el ícono de lápiz en la parte superior derecha.',
          ),
          _buildHelpTile(
            context,
            '¿Cómo elimino un invitado?',
            'Puedes deslizar el nombre del invitado hacia la izquierda en la lista de invitados para eliminarlo de forma rápida.',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildHelpTile(BuildContext context, String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: AppColors.surfaceVariantLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: const TextStyle(color: AppColors.textSecondaryLight),
            ),
          ),
        ],
      ),
    );
  }
}
