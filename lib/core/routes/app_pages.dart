import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testtt/presentation/screens/account_screen.dart';
import 'package:testtt/presentation/screens/cart_screen.dart';
import 'package:testtt/presentation/screens/favorites_screen.dart';
import 'package:testtt/presentation/screens/home_shell.dart';
import 'package:testtt/presentation/screens/login_screen.dart';
import 'package:testtt/presentation/screens/onboarding_screen.dart';
import 'package:testtt/presentation/screens/orders_screen.dart';
import 'package:testtt/presentation/screens/product_screen_details.dart';
import 'package:testtt/presentation/screens/recipe_screen.dart';
import 'package:testtt/presentation/screens/sign_up.dart';
import 'package:testtt/presentation/screens/splash_screen.dart';
import 'package:testtt/presentation/screens/station_checkout_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String favorites = '/favorites';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String account = '/account';
  static const String productDetails = '/product_details';
  static const String stationCheckout = '/station_checkout';
  static const String recipe = '/recipe';
}

class ProductDetailsArgs {
  final String id;
  final String image;
  final String title;
  final String price;
  final String description;
  final String category;

  ProductDetailsArgs({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    this.category = 'Coffee',
  });
}

class AppPages {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _fade(const SplashScreen());
      case AppRoutes.onboarding:
        return _slide(const OnboardingScreen());
      case AppRoutes.login:
        return _slide(const LoginScreen());
      case AppRoutes.signup:
        return _slide(const SignupScreen());
      case AppRoutes.home:
        return _fade(const HomeShell());
      case AppRoutes.favorites:
        return _slide(const FavoritesScreen());
      case AppRoutes.cart:
        return _slide(const CartScreen());
      case AppRoutes.orders:
        return _slide(const OrdersScreen());
      case AppRoutes.account:
        return _slide(const AccountScreen());
      case AppRoutes.recipe:
        return _slide(const RecipeScreen());
      case AppRoutes.stationCheckout:
        return _slide(const StationCheckoutScreen());
      case AppRoutes.productDetails:
        final args = settings.arguments;
        if (args is ProductDetailsArgs) {
          return _slide(
            ProductScreenDetails(
              id: args.id,
              image: args.image,
              title: args.title,
              price: args.price,
              description: args.description,
              category: args.category,
            ),
          );
        }
        return _error('Product details: invalid arguments');
      default:
        return _error('Route not found: ${settings.name}');
    }
  }

  static Route<dynamic> _fade(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  static Route<dynamic> _slide(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.05, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  static Route<dynamic> _error(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
