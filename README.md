# FinShop - Flutter E-Commerce Application

A modern, feature-rich e-commerce mobile application built with Flutter, featuring a beautiful UI, local SQLite database, and comprehensive admin management system.

![Flutter](https://img.shields.io/badge/Flutter-3.10.4-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.4-0175C2?logo=dart)
![SQLite](https://img.shields.io/badge/SQLite-Local%20Database-003B57?logo=sqlite)

## 📱 Features

### User Features
- **Beautiful Landing Page** with hero images, product showcase, and modern UI
- **User Authentication** (Sign Up & Login) with SQLite database
- **Product Browsing** with categories and search functionality
- **Shopping Cart** with add/remove items
- **User Profile** displaying username and email
- **Dark/Light Theme** toggle
- **Responsive Design** with smooth animations

### Admin Features
- **Secure Admin Login** with credentials stored in `admin_access.dart`
- **Product Management** (CRUD operations)
- **User Management** (View and delete users)
- **Order Management** (View orders)
- **Dashboard** with overview statistics

## 🏗️ Project Structure

```
fin_shop/
├── lib/
│   ├── main.dart                      # App entry point
│   ├── models/                        # Data models
│   │   ├── product.dart              # Product model with Rating
│   │   ├── cart_item.dart            # Cart item model
│   │   └── user_model.dart           # User & UserModel (DB)
│   ├── providers/                     # State management (Provider)
│   │   ├── auth_provider.dart        # Authentication state
│   │   ├── product_provider.dart     # Product state
│   │   ├── cart_provider.dart        # Shopping cart state
│   │   ├── user_provider.dart        # User management state
│   │   └── theme_provider.dart       # Theme state
│   ├── screens/                       # UI screens
│   │   ├── landing_page.dart         # Landing page
│   │   ├── splash_screen.dart        # Splash screen
│   │   ├── auth/                     # Authentication screens
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   ├── user/                     # User screens
│   │   │   ├── home_screen.dart
│   │   │   ├── product_details_screen.dart
│   │   │   ├── cart_screen.dart
│   │   │   ├── checkout_screen.dart
│   │   │   └── profile_screen.dart
│   │   └── admin/                    # Admin screens
│   │       ├── admin_login_screen.dart
│   │       ├── admin_dashboard.dart
│   │       ├── product_management_screen.dart
│   │       ├── user_management_screen.dart
│   │       └── order_management_screen.dart
│   ├── services/                      # External services
│   │   ├── api_service.dart          # API integration (Fake Store API)
│   │   └── notification_service.dart # Firebase notifications
│   ├── utils/                         # Utilities
│   │   ├── constants.dart            # App constants & colors
│   │   ├── admin_access.dart         # Admin credentials
│   │   └── database_helper.dart      # SQLite database helper
│   └── widgets/                       # Reusable widgets
│       └── product_card.dart
├── android/                           # Android configuration
├── ios/                              # iOS configuration
├── pubspec.yaml                      # Dependencies
└── README.md                         # This file
```

## 🛠️ Technologies & Packages

### Core
- **Flutter SDK**: ^3.10.4
- **Dart**: ^3.10.4

### State Management
- **provider**: ^6.1.5+1 - State management solution

### Database
- **sqflite**: Local SQLite database for user authentication and product storage
- **path**: Path manipulation for database files

### UI & Design
- **google_fonts**: ^6.3.3 - Custom fonts (Poppins, Inter)
- **cached_network_image**: ^3.4.1 - Efficient image loading and caching
- **flutter_rating_bar**: ^4.0.1 - Product rating display

### Backend Integration
- **dio**: ^5.9.0 - HTTP client for API calls
- **firebase_core**: ^4.3.0 - Firebase initialization
- **firebase_messaging**: ^16.1.0 - Push notifications

### Storage
- **shared_preferences**: ^2.5.4 - Local key-value storage for session management

### Utilities
- **intl**: ^0.20.2 - Internationalization and date formatting

## 🗄️ Database Schema

### Users Table
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  email TEXT NOT NULL,
  firstname TEXT NOT NULL,
  lastname TEXT NOT NULL
)
```

### Products Table
```sql
CREATE TABLE products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  price REAL NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  image TEXT NOT NULL,
  rating_rate REAL DEFAULT 0.0,
  rating_count INTEGER DEFAULT 0
)
```

## 🎨 Design System

### Colors
- **Primary Light**: `#6200EE` (Purple)
- **Secondary Light**: `#03DAC6` (Teal)
- **Background Light**: `#F5F5F5`
- **Primary Dark**: `#BB86FC`
- **Background Dark**: `#121212`

### Typography
- **Headings**: Poppins (Bold, Semi-Bold)
- **Body Text**: Inter (Regular, Medium)

### Spacing
- Small: 8.0
- Medium: 16.0
- Large: 24.0

### Border Radius
- Small: 8.0
- Medium: 12.0
- Large: 20.0

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.10.4 or higher)
- Dart SDK (3.10.4 or higher)
- Android Studio / VS Code
- Android Emulator or iOS Simulator

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd fin_shop
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

## 🔐 Admin Access

To access the admin dashboard:

1. Click **"Admin Access"** on the landing page
2. Enter credentials:
   - **Email**: `admin@finshop.com`
   - **Password**: `admin123`

> **Note**: Admin credentials are stored in `lib/utils/admin_access.dart` and can be modified.

## 📖 Usage Guide

### For Users

1. **Sign Up**: Create a new account with email, username, and password
2. **Login**: Use your credentials to access the app
3. **Browse Products**: View products by category or search
4. **Add to Cart**: Select products and add them to your cart
5. **Checkout**: Complete your purchase
6. **Profile**: View and manage your account settings

### For Admins

1. **Login**: Use admin credentials to access the dashboard
2. **Manage Products**: Add, edit, or delete products
3. **Manage Users**: View registered users and manage accounts
4. **View Orders**: Monitor customer orders

## 🔄 State Management

The app uses the **Provider** pattern for state management:

- **AuthProvider**: Manages user authentication state
- **ProductProvider**: Handles product data and operations
- **CartProvider**: Manages shopping cart state
- **UserProvider**: Admin user management
- **ThemeProvider**: Theme switching (Dark/Light mode)

## 💾 Data Persistence

### SQLite Database
- User accounts (signup/login)
- Product catalog
- Local data storage

### SharedPreferences
- Authentication tokens
- User session data
- Theme preferences

## 🎯 Key Features Implementation

### Authentication Flow
1. User signs up → Data saved to SQLite
2. User logs in → Credentials validated against database
3. Session token stored in SharedPreferences
4. Auto-login on app restart if token exists

### Product Management
1. Products stored in SQLite database
2. Admin can perform CRUD operations
3. Changes persist locally
4. Categories dynamically generated from products

### Shopping Cart
1. In-memory cart management
2. Add/remove items
3. Quantity adjustment
4. Total price calculation

## 🌐 API Integration

The app integrates with **Fake Store API** for initial product data:
- Base URL: `https://fakestoreapi.com`
- Endpoints: Products, Categories, Users

## 🎨 UI Highlights

### Landing Page
- Hero image with gradient background
- Product showcase carousel
- Feature highlights (Free Shipping, Secure Payment, 24/7 Support)
- Professional footer with social links

### Product Cards
- High-quality images
- Rating display
- Price and category information
- Smooth hover effects

### Admin Dashboard
- Statistics overview
- Quick access to management screens
- Clean, professional design

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web (with limitations)
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🐛 Known Issues

- Product images require internet connection
- Cart data is not persisted (resets on app restart)
- No payment gateway integration (checkout is simulated)

## 🔮 Future Enhancements

- [ ] Order history persistence
- [ ] Payment gateway integration
- [ ] Product reviews and ratings
- [ ] Wishlist functionality
- [ ] Push notifications for orders
- [ ] Multi-language support
- [ ] Advanced search filters
- [ ] Product recommendations

## 📄 License

This project is created for educational purposes.

## 👨‍💻 Author

Created as a Flutter e-commerce demonstration project.

---

**Note**: This is a demonstration project. For production use, implement proper security measures including:
- Password hashing (bcrypt, argon2)
- JWT token authentication
- HTTPS for all API calls
- Input validation and sanitization
- Proper error handling
- Rate limiting
- Secure admin credentials storage
