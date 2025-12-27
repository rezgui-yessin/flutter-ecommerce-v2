# FinShop - Flutter E-commerce Application

FinShop is a comprehensive, full-featured e-commerce mobile application built with Flutter. It demonstrates a complete shopping lifecycle from user authentication to product browsing, cart management, and checkout, alongside a dedicated Admin Dashboard.

## 🚀 Key Features

### 👤 User Application
-   **Authentication**: Secure Login and Sign Up flows integrated with the FakeStore API.
-   **Modern UI**: Beautifully designed screens with gradient headers, custom shapes, and dark mode support.
-   **Product Discovery**:
    -   **Home**: "Infinite" scrolling grid with lazy loading (Slivers) for optimal performance.
    -   **Search**: Real-time product search with instant suggestions.
    -   **Categories**: Filter products by category (Electronics, Jewelery, etc.).
-   **Shopping Cart**: Add items, adjust quantities, and remove products.
-   **Checkout**: Mock checkout process with address input and payment selection.
-   **Profile**: User details and Application Settings (Dark Mode Toggle).

### 🛠 Admin Dashboard
-   **Overview**: Key statistics (Revenue, Users, Orders).
-   **Management**:
    -   **Products**: View, Add (Mock), Edit, and Delete products.
    -   **Orders**: Track order status (Pending, Shipped, Delivered).
    -   **Users**: Manage registered users.

### ⚙️ Technical Highlights
-   **State Management**: `Provider` for efficient state handling usage across the app.
-   **Networking**: `Dio` for robust API requests with custom error handling.
-   **API Integration**: Fully connected to [FakeStore API](https://fakestoreapi.com/).
-   **Performance**: Optimized `CustomScrollView` and `SliverGrid` implementation to handle large lists without lag.
-   **Notifications**: Integrated `firebase_messaging` structure (requires setup).

## 🛠 Tech Stack
-   **Framework**: Flutter (Dart)
-   **State Management**: Provider
-   **Networking**: Dio
-   **Storage**: Shared Preferences
-   **UI Components**: Material 3, Cached Network Image, Flutter Rating Bar

## 🛡 Implementation Details (What was done)
This project was built from scratch with a focus on clean architecture and user experience:

1.  **Project Structure**: Organized into clear layers (`providers`, `services`, `screens`, `models`) for maintainability.
2.  **Robust Error Handling**:
    -   Caught specific network errors (like `SocketException`) to provide user-friendly "No Internet" messages.
    -   Improved feedback on Login/Signup failures.
3.  **UI/UX Revamp**:
    -   Transformed basic form screens into premium interfaces with curved headers and styled inputs.
    -   Ensured full support for **Dark Mode** throughout the app.
4.  **Performance Tuning**: Refactored the main product grid from a basic `GridView` to a `CustomScrollView` with `Slivers`. This fixed UI jank/lag by implementing lazy loading for list items.

## 🏁 How to Run

1.  **Prerequisites**: Ensure Flutter SDK is installed.
2.  **Get Dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the App**:
    ```bash
    flutter run
    ```
    *Note: For best performance, run in profile or release mode (`flutter run --profile`).*

## 📱 Screenshots
*(Add screenshots of your beautiful Login, Home, and Dark Mode screens here)*
