import 'package:clean_bloc_supabase/core/error/failures.dart';
import 'package:clean_bloc_supabase/core/error/exception.dart';
import 'package:clean_bloc_supabase/feature/auth/data/data_sources/auth_supabase_data_source.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/entities/user.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final AuthSupabaseDataSource authSupabaseDataSource;
  const AuthRepositoryImplementation(this.authSupabaseDataSource);
  @override
  Future<Either<Failures, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failures, User>> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await authSupabaseDataSource.signupWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
