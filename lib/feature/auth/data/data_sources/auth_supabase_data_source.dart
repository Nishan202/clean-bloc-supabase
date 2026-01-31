import 'package:clean_bloc_supabase/core/error/exception.dart';
import 'package:clean_bloc_supabase/feature/auth/data/models/user_model.dart';
import 'package:pretty_logger/pretty_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthSupabaseDataSource {
  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthSupabaseDataSourceImplementation implements AuthSupabaseDataSource {
  final SupabaseClient supabaseClient;
  const AuthSupabaseDataSourceImplementation(this.supabaseClient);
  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw const ServerException('User is Null');
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthApiException catch (e) {
      Logger.red(e.message);
      throw ServerException(e.message);
    } catch (e) {
      Logger.red(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );
      if (response.user == null) {
        throw const ServerException('user is null');
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      Logger.red(e.message);
      throw ServerException(e.message);
    } catch (e) {
      Logger.red(e.toString());
      throw ServerException(e.toString());
    }
  }
}
