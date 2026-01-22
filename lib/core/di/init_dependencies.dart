import 'package:clean_bloc_supabase/core/supabase/secrets.dart';
import 'package:clean_bloc_supabase/feature/auth/data/data_sources/auth_supabase_data_source.dart';
import 'package:clean_bloc_supabase/feature/auth/data/repositories/auth_repository_implementation.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/repository/auth_repository.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/user_sign_up.dart';
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
}

void _initAuth() {
  serviceLocator.registerFactory<AuthSupabaseDataSource>(
    () =>
        AuthSupabaseDataSourceImplementation(serviceLocator<SupabaseClient>()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () =>
        AuthRepositoryImplementation(serviceLocator<AuthSupabaseDataSource>()),
  );

  serviceLocator.registerLazySingleton(
    () => UserSignUp(authRepository: serviceLocator<AuthRepository>()),
  );
}
