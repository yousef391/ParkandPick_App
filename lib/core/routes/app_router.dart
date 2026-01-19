import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testtt/core/di/injection.dart';
import 'package:testtt/data/models/product_model.dart';
import 'package:testtt/presentation/screens/cart_screen.dart';
import 'package:testtt/presentation/screens/home_shell.dart';
import 'package:testtt/presentation/screens/login_screen.dart';
import 'package:testtt/presentation/screens/onboarding_screen.dart';
import 'package:testtt/presentation/screens/product_screen_details.dart';
import 'package:testtt/presentation/screens/sign_up.dart';
import 'package:testtt/presentation/screens/station_checkout_screen.dart';
import 'package:testtt/presentation/screens/order_success_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeShell(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        // We'll need to pass the product object or id.
        // For now relying on simple navigation, but GoRouter prefers ID.
        // If the app expects an object, we might need to fetch it or pass as extra.
        // Assuming we pass object in extra for now to minimize refactor.
        final extra = state.extra as Map<String, dynamic>?;
        final product = extra?['product'] as Product?;

        if (product == null) {
          return const Scaffold(
            body: Center(child: Text("Product not found")),
          );
        }

        return ProductScreenDetails(
          id: product.id,
          image: product.imageUrl,
          title: product.name,
          price: product.price.toString(),
          description: product.description,
          category: product.category,
        );
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const StationCheckoutScreen(),
    ),
    GoRoute(
      path: '/order-success',
      builder: (context, state) => const OrderSuccessScreen(),
    ),
  ],
  redirect: (context, state) {
    final prefs = getIt<SharedPreferences>();
    final supabase = getIt<SupabaseClient>();

    final bool onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
    final bool loggedIn = supabase.auth.currentUser != null;

    final isOnboarding = state.matchedLocation == '/onboarding';
    final isLogin = state.matchedLocation == '/login';
    final isSignup = state.matchedLocation == '/signup';

    if (!onboardingSeen) {
      return '/onboarding';
    }

    if (!loggedIn) {
      if (isOnboarding) return '/login'; // If finishing onboarding
      if (isLogin || isSignup) return null; // Allow login/signup
      return '/login';
    }

    // If logged in
    if (isOnboarding || isLogin || isSignup) {
      return '/home';
    }

    return null;
  },
);
