import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/user/home_screen.dart';
import 'screens/user/product_details_screen.dart';
import 'screens/user/cart_screen.dart';
import 'screens/user/checkout_screen.dart';
import 'screens/user/profile_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/landing_page.dart';
import 'screens/admin/admin_login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await NotificationService.initialize();
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  runApp(const FinShopApp());
}

class FinShopApp extends StatelessWidget {
  const FinShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'FinShop',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: AppColors.primaryLight,
              brightness: Brightness.light,
              scaffoldBackgroundColor: AppColors.backgroundLight,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: AppColors.primaryDark,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppColors.backgroundDark,
            ),
            home: const SplashScreen(),
            routes: {
              '/landing': (context) => const LandingPage(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/home': (context) => const HomeScreen(),
              '/cart': (context) => const CartScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/checkout': (context) => const CheckoutScreen(),
              '/admin': (context) => const AdminDashboard(),
              '/admin_login': (context) => const AdminLoginScreen(),
            },
          );
        },
      ),
    );
  }
}
