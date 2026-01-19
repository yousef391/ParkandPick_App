// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../data/repositories/auth_repository.dart' as _i481;
import '../../data/repositories/cart_repository.dart' as _i865;
import '../../data/repositories/favorites_repository.dart' as _i803;
import '../../data/repositories/location_repository.dart' as _i535;
import '../../data/repositories/order_repository.dart' as _i893;
import '../../data/repositories/payment_repository.dart' as _i753;
import '../../data/repositories/product_repository.dart' as _i358;
import '../../data/repositories/station_repository.dart' as _i1058;
import '../../data/repositories/user_repository.dart' as _i517;
import '../../presentation/cubits/auth/auth_cubit.dart' as _i33;
import '../../presentation/cubits/cart/cart_cubit.dart' as _i651;
import '../../presentation/cubits/favorites/favorites_cubit.dart' as _i881;
import '../../presentation/cubits/location/location_cubit.dart' as _i482;
import '../../presentation/cubits/onboarding/onboarding_cubit.dart' as _i97;
import '../../presentation/cubits/order/order_cubit.dart' as _i993;
import '../../presentation/cubits/payment/payment_cubit.dart' as _i596;
import '../../presentation/cubits/product/product_cubit.dart' as _i951;
import '../../presentation/cubits/product_details/product_details_cubit.dart'
    as _i223;
import '../../presentation/cubits/station/station_cubit.dart' as _i39;
import '../../presentation/cubits/user/user_cubit.dart' as _i40;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i223.ProductDetailsCubit>(() => _i223.ProductDetailsCubit());
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabase);
    gh.lazySingleton<_i865.CartRepository>(() => _i865.CartRepository());
    gh.lazySingleton<_i803.FavoritesRepository>(
        () => _i803.FavoritesRepository());
    gh.lazySingleton<_i358.ProductRepository>(
        () => _i358.ProductRepositoryImpl());
    gh.lazySingleton<_i1058.StationRepository>(
        () => _i1058.StationRepositoryImpl());
    gh.lazySingleton<_i893.OrderRepository>(() => _i893.OrderRepositoryImpl());
    gh.lazySingleton<_i535.LocationRepository>(
        () => _i535.LocationRepositoryImpl());
    gh.factory<_i881.FavoritesCubit>(
        () => _i881.FavoritesCubit(gh<_i803.FavoritesRepository>()));
    gh.factory<_i482.LocationCubit>(
        () => _i482.LocationCubit(gh<_i535.LocationRepository>()));
    gh.lazySingleton<_i481.AuthRepository>(
        () => _i481.AuthRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i753.PaymentRepository>(
        () => _i753.PaymentRepositoryImpl());
    gh.factory<_i651.CartCubit>(
        () => _i651.CartCubit(gh<_i865.CartRepository>()));
    gh.factory<_i39.StationCubit>(
        () => _i39.StationCubit(gh<_i1058.StationRepository>()));
    gh.factory<_i97.OnboardingCubit>(
        () => _i97.OnboardingCubit(gh<_i460.SharedPreferences>()));
    gh.factory<_i951.ProductCubit>(
        () => _i951.ProductCubit(gh<_i358.ProductRepository>()));
    gh.factory<_i33.AuthCubit>(
        () => _i33.AuthCubit(gh<_i481.AuthRepository>()));
    gh.lazySingleton<_i517.UserRepository>(
        () => _i517.UserRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i40.UserCubit>(
        () => _i40.UserCubit(gh<_i517.UserRepository>()));
    gh.factory<_i596.PaymentCubit>(
        () => _i596.PaymentCubit(gh<_i753.PaymentRepository>()));
    gh.factory<_i993.OrderCubit>(
        () => _i993.OrderCubit(gh<_i893.OrderRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
