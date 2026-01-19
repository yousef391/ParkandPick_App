import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:testtt/data/repositories/payment_repository.dart';
import 'package:testtt/presentation/cubits/payment/payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentCubit(this._paymentRepository) : super(PaymentInitial());

  Future<void> initPaymentSheet(double amount,
      {String currency = 'usd'}) async {
    emit(PaymentLoading());
    final result = await _paymentRepository.initPaymentSheet(
      amount: amount,
      currency: currency,
    );

    result.fold(
      (failure) => emit(PaymentFailure(failure.message)),
      (_) => emit(const PaymentReady()),
    );
  }

  Future<bool> presentPaymentSheet() async {
    // emit(PaymentLoading()); // Optional: loading while presenting? usually handled by SDK
    final result = await _paymentRepository.presentPaymentSheet();

    return result.fold(
      (failure) {
        emit(PaymentFailure(failure.message));
        return false;
      },
      (_) {
        emit(PaymentSuccess());
        return true;
      },
    );
  }
}
