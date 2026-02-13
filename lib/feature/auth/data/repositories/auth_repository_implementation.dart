import 'package:clean_bloc_supabase/core/error/failures.dart';
import 'package:clean_bloc_supabase/core/error/exception.dart';
import 'package:clean_bloc_supabase/core/network/connection_checker.dart';
import 'package:clean_bloc_supabase/feature/auth/data/data_sources/auth_supabase_data_source.dart';
import 'package:clean_bloc_supabase/core/entities/user.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final ConnectionChecker connectionChecker;
  final AuthSupabaseDataSource authSupabaseDataSource;
  const AuthRepositoryImplementation(
    this.authSupabaseDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failures, User>> currentUserDetails() async {
    try {
      final user = await authSupabaseDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failures('User not Logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _getUser(
      () async => await authSupabaseDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failures, User>> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) {
    return _getUser(
      () async => await authSupabaseDataSource.signupWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failures, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failures('No internet connection!'));
      }
      final user = await fn();
      return right(user);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
