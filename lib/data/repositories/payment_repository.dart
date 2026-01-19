import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:injectable/injectable.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testtt/core/failure.dart';

abstract class PaymentRepository {
  Future<Either<Failure, void>> initPaymentSheet({
    required double amount,
    required String currency,
  });

  Future<Either<Failure, void>> presentPaymentSheet();
}

@LazySingleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  @override
  Future<Either<Failure, void>> initPaymentSheet({
    required double amount,
    required String currency,
  }) async {
    try {
      // 1. Get payment intent client secret from backend
      final clientSecret = await _createPaymentIntent(amount, currency);

      // 2. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Park and Pick',
          style: ThemeMode.light,
          // appearance: PaymentSheetAppearance(
          //   colors: PaymentSheetAppearanceColors(
          //     primary: ColorsManager.primary,
          //   ),
          // ),
        ),
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return const Right(null);
    } catch (e) {
      if (e is StripeException) {
        return Left(
            ServerFailure(e.error.localizedMessage ?? 'Payment failed'));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  // Create Payment Intent via Supabase Function
  Future<String> _createPaymentIntent(double amount, String currency) async {
    // Call the Edge Function 'create_payment_intent'
    // Ensure you have deployed this function to Supabase!
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'create_payment_intent',
        body: {
          'amount': amount.toInt(), // Amount in cents
          'currency': currency,
        },
      );

      final data = response.data;
      if (data == null || data['clientSecret'] == null) {
        throw Exception("Invalid response from payment function");
      }
      print(data['clientSecret']);
      return data['clientSecret'];
    } catch (e) {
      throw Exception(
          'Failed to create PaymentIntent: $e. Did you deploy the function?');
    }
  }
}
