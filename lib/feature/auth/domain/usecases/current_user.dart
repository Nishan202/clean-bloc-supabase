import 'package:clean_bloc_supabase/core/error/failures.dart';
import 'package:clean_bloc_supabase/core/usecase/usecase.dart';
import 'package:clean_bloc_supabase/core/entities/user.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);
  @override
  Future<Either<Failures, User>> call(NoParams params) async {
    return await authRepository.currentUserDetails();
  }
}
