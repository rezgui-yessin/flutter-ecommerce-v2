import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'), // Mock image
          ),
          const SizedBox(height: 16),
          FutureBuilder<String?>(
            future: authProvider.getUsername(),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? 'User',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text('user@example.com'), // Mock email as we don't store it in basic auth flow
          const SizedBox(height: 32),
          
          Card(
            child: Column(
              children: [
                 SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
                const Divider(),
                 ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {},
                ),
                 const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    await authProvider.logout();
                   if (context.mounted) {
                      Navigator.of(context).pushReplacementNamed('/landing');
                   }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
