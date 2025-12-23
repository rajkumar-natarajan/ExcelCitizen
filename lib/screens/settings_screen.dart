import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../models/question.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SettingsController(),
      builder: (context, child) {
        final controller = SettingsController();
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            children: [
              _buildSectionHeader(context, 'Preferences'),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: Text(controller.language.displayName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(context, controller),
              ),
              ListTile(
                leading: const Icon(Icons.tune),
                title: const Text('Difficulty Level'),
                subtitle: Text(controller.defaultDifficulty.displayName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showDifficultyDialog(context, controller),
              ),
              _buildSectionHeader(context, 'App'),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                value: controller.themeMode == ThemeMode.dark,
                onChanged: (value) => controller.toggleTheme(value),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                value: true,
                onChanged: (value) {},
              ),
              _buildSectionHeader(context, 'About'),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Version'),
                subtitle: Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Language'),
        children: Language.values.map((lang) {
          return SimpleDialogOption(
            onPressed: () {
              controller.setLanguage(lang);
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Text(lang.flag),
                const SizedBox(width: 12),
                Text(lang.displayName),
                if (controller.language == lang) ...[
                  const Spacer(),
                  const Icon(Icons.check, color: Colors.blue),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Difficulty'),
        children: Difficulty.values.map((difficulty) {
          return SimpleDialogOption(
            onPressed: () {
              controller.setDifficulty(difficulty);
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(difficulty.displayName),
                ),
                if (controller.defaultDifficulty == difficulty)
                  const Icon(Icons.check, color: Colors.blue),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
