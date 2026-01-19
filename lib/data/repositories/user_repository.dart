import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:testtt/core/failure.dart';

/// User Profile model
class UserProfile {
  final String id;
  final String? name;
  final String? email;
  final String? avatarPath;

  const UserProfile({
    required this.id,
    this.name,
    this.email,
    this.avatarPath,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarPath,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      avatarPath: json['avatar_path'] as String?,
    );
  }
}

/// User Repository - Manages user profile operations
abstract class UserRepository {
  Future<Either<Failure, UserProfile>> getProfile();
  Future<Either<Failure, UserProfile>> updateProfile(
      {String? name, String? email});
  Future<Either<Failure, UserProfile>> updateAvatar(String? avatarPath);
  Future<Either<Failure, UserProfile>> uploadAvatar(File imageFile);
}

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final SupabaseClient _supabaseClient;

  UserRepositoryImpl(this._supabaseClient);

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return Left(AuthFailure('User not authenticated'));
      }

      final data = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return Right(UserProfile.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
      {String? name, String? email}) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return Left(AuthFailure('User not authenticated'));
      }

      final updates = {
        'id': user.id,
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (name != null) updates['name'] = name;
      if (email != null) updates['email'] = email;

      final data = await _supabaseClient
          .from('profiles')
          .upsert(updates)
          .select()
          .single();

      return Right(UserProfile.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateAvatar(String? avatarPath) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return Left(AuthFailure('User not authenticated'));
      }

      final updates = {
        'id': user.id,
        'avatar_path': avatarPath,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final data = await _supabaseClient
          .from('profiles')
          .upsert(updates)
          .select()
          .single();

      return Right(UserProfile.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> uploadAvatar(File imageFile) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return Left(AuthFailure('User not authenticated'));
      }

      final fileExt = imageFile.path.split('.').last;
      final fileName =
          '${user.id}/${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;

      await _supabaseClient.storage.from('avatars').upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(upsert: true),
          );

      final imageUrl =
          _supabaseClient.storage.from('avatars').getPublicUrl(filePath);

      return await updateAvatar(imageUrl);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
