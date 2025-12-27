import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text('U${index + 1}')),
          title: Text('User ${index + 1}'),
          subtitle: const Text('user@example.com'),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'block', child: Text('Block User')),
              const PopupMenuItem(value: 'details', child: Text('View Details')),
            ],
          ),
        );
      },
    );
  }
}
