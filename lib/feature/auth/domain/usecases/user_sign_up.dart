import 'package:clean_bloc_supabase/feature/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:clean_bloc_supabase/core/error/failures.dart';
import 'package:clean_bloc_supabase/core/usecase/usecase.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/repository/auth_repository.dart';

class UserSignUp implements Usecase<User, UserSignupParameters> {
  final AuthRepository authRepository;
  const UserSignUp({required this.authRepository});
  @override
  Future<Either<Failures, User>> call(
    UserSignupParameters userSignUpParameters,
  ) async {
    return await authRepository.signupWithEmailPassword(
      name: userSignUpParameters.name,
      email: userSignUpParameters.email,
      password: userSignUpParameters.password,
    );
  }
}

class UserSignupParameters {
  final String email;
  final String password;
  final String name;
  UserSignupParameters({
    required this.email,
    required this.password,
    required this.name,
  });
}
