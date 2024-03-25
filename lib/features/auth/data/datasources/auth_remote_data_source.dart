import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      if (currentUserSession != null) {
        final res = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);

        return UserModel.fromMap(res.first)
            .copyWith(email: currentUserSession!.user.email);
      }

      return null;
    } catch (err) {
      throw ServerException(err.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw const ServerException("User is null");
      }
      return UserModel.fromMap(response.user!.toJson())
          .copyWith(email: currentUserSession!.user.email);
    } catch (err) {
      throw ServerException(err.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {"name": name},
      );
      if (response.user == null) {
        throw const ServerException("User is null");
      }
      return UserModel.fromMap(response.user!.toJson())
          .copyWith(email: currentUserSession!.user.email);
    } catch (err) {
      throw ServerException(err.toString());
    }
  }
}
