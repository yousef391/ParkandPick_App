import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testtt/core/di/injection.dart';
import 'package:testtt/core/routes/app_router.dart';
import 'package:testtt/presentation/cubits/auth/auth_cubit.dart';
import 'package:testtt/presentation/cubits/cart/cart_cubit.dart';
import 'package:testtt/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:testtt/presentation/cubits/location/location_cubit.dart';
import 'package:testtt/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:testtt/presentation/cubits/order/order_cubit.dart';
import 'package:testtt/presentation/cubits/product/product_cubit.dart';
import 'package:testtt/presentation/cubits/product_details/product_details_cubit.dart';
import 'package:testtt/presentation/cubits/station/station_cubit.dart';
import 'package:testtt/presentation/cubits/user/user_cubit.dart';
import 'package:testtt/presentation/cubits/payment/payment_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://sfytyykggpqvdpjydtgk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNmeXR5eWtnZ3BxdmRwanlkdGdrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg1NzQ0ODUsImV4cCI6MjA4NDE1MDQ4NX0.h_4Ix7fHQi_ZrC6gDsMpE_A-KKG5AKHr4Py1_NgfSmY',
  );

  // Initialize Stripe
  // TODO: Replace with your actual Stripe Publishable Key
  Stripe.publishableKey =
      'pk_test_51SrJzPDF89g4ywL6m5DvkW0rxLVQzzagBFbrOaiK3sk7h1CTtv55lleACNOplTIyJD4MtbNXTG3Jhp6ZNZ1jNi9700Ky5g5zde';
  await Stripe.instance.applySettings();

  // Initialize Dependency Injection
  await configureDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<OnboardingCubit>()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<ProductCubit>()),
        BlocProvider(create: (_) => getIt<ProductDetailsCubit>()),
        BlocProvider(create: (_) => getIt<CartCubit>()),
        BlocProvider(create: (_) => getIt<OrderCubit>()),
        BlocProvider(create: (_) => getIt<FavoritesCubit>()),
        BlocProvider(create: (_) => getIt<StationCubit>()),
        BlocProvider(create: (_) => getIt<LocationCubit>()),
        BlocProvider(create: (_) => getIt<LocationCubit>()),
        BlocProvider(create: (_) => getIt<UserCubit>()),
        BlocProvider(create: (_) => getIt<PaymentCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
        );
      },
    );
  }
}
