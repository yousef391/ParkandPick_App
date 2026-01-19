import 'package:dartz/dartz.dart';
import 'package:testtt/core/failure.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testtt/data/models/product_model.dart';

/// Product Repository - Handles product data operations
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> fetchProducts();
  Future<Either<Failure, List<Product>>> fetchProductsByCategory(
      String category);
  Future<Either<Failure, Product>> fetchProductById(String id);
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<Either<Failure, List<Product>>> fetchProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .order('name', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      final products = data.map((json) => Product.fromSupabase(json)).toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> fetchProductsByCategory(
      String category) async {
    try {
      var query = Supabase.instance.client.from('products').select();

      if (category != 'all') {
        query = query.eq('category', category);
      }

      final response = await query.order('name', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      final products = data.map((json) => Product.fromSupabase(json)).toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> fetchProductById(String id) async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .eq('id', id)
          .single();

      return Right(Product.fromSupabase(response));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .ilike('name', '%$query%')
          .order('name', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      final products = data.map((json) => Product.fromSupabase(json)).toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
