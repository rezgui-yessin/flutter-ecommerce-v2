import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final users = userProvider.users;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditUserDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: userProvider.isLoading 
      ? const Center(child: CircularProgressIndicator())
      : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(child: Text(user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U')),
              title: Text(user.username),
              subtitle: Text(user.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue), 
                    onPressed: () => _showAddEditUserDialog(context, isEdit: true, user: user)
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red), 
                    onPressed: () => _confirmDelete(context, user.id)
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('No')),
          TextButton(onPressed: () async {
             Navigator.of(ctx).pop();
             try {
                await Provider.of<UserProvider>(context, listen: false).deleteUser(id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User deleted successfully')));
                }
             } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
                }
             }
          }, child: const Text('Yes')),
        ],
      ),
    );
  }

  void _showAddEditUserDialog(BuildContext context, {bool isEdit = false, User? user}) {
    final emailController = TextEditingController(text: isEdit ? user?.email : '');
    final usernameController = TextEditingController(text: isEdit ? user?.username : '');
    final firstnameController = TextEditingController(text: isEdit ? user?.name.firstname : '');
    final lastnameController = TextEditingController(text: isEdit ? user?.name.lastname : '');
    final phoneController = TextEditingController(text: isEdit ? user?.phone : '');
    
    // Address (Simplified for demo)
    final cityController = TextEditingController(text: isEdit ? user?.address.city : 'kilcoole');
    final streetController = TextEditingController(text: isEdit ? user?.address.street : 'new road');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit User' : 'Add User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: usernameController, decoration: const InputDecoration(labelText: 'Username')),
              Row(
                children: [
                  Expanded(child: TextField(controller: firstnameController, decoration: const InputDecoration(labelText: 'First Name'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: lastnameController, decoration: const InputDecoration(labelText: 'Last Name'))),
                ],
              ),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
              TextField(controller: cityController, decoration: const InputDecoration(labelText: 'City')),
              TextField(controller: streetController, decoration: const InputDecoration(labelText: 'Street')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newUser = User(
                id: isEdit ? user!.id : DateTime.now().millisecondsSinceEpoch,
                email: emailController.text,
                username: usernameController.text,
                name: Name(firstname: firstnameController.text, lastname: lastnameController.text),
                address: Address(city: cityController.text, street: streetController.text, number: 3, zipcode: '0000'),
                phone: phoneController.text,
              );

              try {
                if (isEdit) {
                   await Provider.of<UserProvider>(context, listen: false).updateUser(user!.id, newUser);
                } else {
                   await Provider.of<UserProvider>(context, listen: false).addUser(newUser);
                }
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            }, 
            child: Text(isEdit ? 'Update' : 'Add')
          ),
        ],
      ),
    );
  }
}
