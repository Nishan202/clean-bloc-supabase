import 'package:clean_bloc_supabase/core/error/failures.dart';
import 'package:clean_bloc_supabase/core/usecase/usecase.dart';
import 'package:clean_bloc_supabase/core/entities/user.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements Usecase<User, UserLoginParameters> {
  final AuthRepository authRepository;
  const UserLogin({required this.authRepository});
  @override
  Future<Either<Failures, User>> call(
    UserLoginParameters userSignUpParameters,
  ) async {
    return await authRepository.loginWithEmailPassword(
      email: userSignUpParameters.email,
      password: userSignUpParameters.password,
    );
  }
}

class UserLoginParameters {
  final String email;
  final String password;
  UserLoginParameters({required this.email, required this.password});
}
