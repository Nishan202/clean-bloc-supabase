import 'package:clean_bloc_supabase/core/cubit/app_user/app_user_cubit.dart';
import 'package:clean_bloc_supabase/core/supabase/secrets.dart';
import 'package:clean_bloc_supabase/feature/auth/data/data_sources/auth_supabase_data_source.dart';
import 'package:clean_bloc_supabase/feature/auth/data/repositories/auth_repository_implementation.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/repository/auth_repository.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/current_user.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/user_log_in.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabse = await Supabase.initialize(
    url: Secrets.url,
    anonKey: Secrets.publishableAPIKey,
  );
  serviceLocator.registerLazySingleton(() => supabse.client);
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // Data Source
  serviceLocator
    ..registerFactory<AuthSupabaseDataSource>(
      () => AuthSupabaseDataSourceImplementation(
        serviceLocator<SupabaseClient>(),
      ),
    )
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImplementation(
        serviceLocator<AuthSupabaseDataSource>(),
      ),
    )
    // Use cases
    ..registerFactory(() => UserSignUp(authRepository: serviceLocator()))
    ..registerFactory(() => UserLogin(authRepository: serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userLogin: serviceLocator<UserLogin>(),
        currentUser: serviceLocator<CurrentUser>(),
        appUserCubit: serviceLocator<AppUserCubit>(),
      ),
    );
}
