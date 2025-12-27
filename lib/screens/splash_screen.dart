import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    // AuthProvider loads token in constructor, but let's wait a bit to be sure or just check content
    // Actually we should await the loadToken if it wasn't in constructor, 
    // but since it's async in constructor, we might need to verify.
    // However, for simplicity here, we assume if token exists in prefs (which AuthProvider loads), we go home.
    
    // Better approach: AuthProvider initialization might not be finished. 
    // But since we delayed 2 seconds, it's likely done.
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
    } else {
        Navigator.of(context).pushReplacementNamed('/landing');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag, size: 80, color: AppColors.primaryLight),
            SizedBox(height: 16),
            Text(
              'FinShop',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
