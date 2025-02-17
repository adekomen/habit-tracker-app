import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/theme_controller.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nous contacter'),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pour toute question ou suggestion, contactez-nous via les canaux suivants :',
              style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            _buildContactItem(
              icon: Icons.email,
              label: 'Email : support@example.com',
              themeProvider: themeProvider,
            ),
            _buildContactItem(
              icon: Icons.phone,
              label: 'Téléphone : +33 1 23 45 67 89',
              themeProvider: themeProvider,
            ),
            _buildContactItem(
              icon: Icons.web,
              label: 'Site web : www.example.com',
              themeProvider: themeProvider,
            ),
            const SizedBox(height: 20),
            Text(
              'Nous vous répondrons dans les plus brefs délais.',
              style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.grey : Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required ThemeProvider themeProvider,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}