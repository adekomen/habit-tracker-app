import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Listes de tâches et d\'habitudes', themeProvider),
          _buildSettingItem(
            icon: Icons.list,
            title: 'Gérer les listes',
            themeProvider: themeProvider,
            onTap: () {
              // Naviguer vers la gestion des listes
            },
          ),
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Notifications et alarmes',
            themeProvider: themeProvider,
            onTap: () {
              // Naviguer vers les notifications
            },
          ),
          _buildSectionTitle('Personnalisation', themeProvider),
          _buildSettingItem(
            icon: Icons.palette,
            title: 'Personnaliser l\'apparence',
            themeProvider: themeProvider,
            onTap: () {
              // Naviguer vers la personnalisation
            },
          ),
          _buildSettingItem(
            icon: Icons.lock,
            title: 'Écran verrouillé',
            themeProvider: themeProvider,
            onTap: () {
              // Naviguer vers les paramètres de l'écran verrouillé
            },
          ),
          _buildSectionTitle('Sauvegarde et langue', themeProvider),
          _buildSettingItem(
            icon: Icons.save,
            title: 'Sauvegarder les données',
            themeProvider: themeProvider,
            onTap: () {
              // Naviguer vers la sauvegarde
            },
          ),
          _buildSettingItem(
            icon: Icons.language,
            title: 'Langue',
            themeProvider: themeProvider,
            onTap: () {
              // Naviguer vers les paramètres de langue
            },
          ),
          _buildSectionTitle('À propos', themeProvider),
          _buildSettingItem(
            icon: Icons.info,
            title: 'Licences',
            themeProvider: themeProvider,
            onTap: () {
              // Naviguer vers les licences
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: themeProvider.isDarkMode ? Colors.grey : Colors.black54,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required ThemeProvider themeProvider,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}