import 'package:clean_bloc_supabase/core/cubit/app_user/app_user_cubit.dart';
import 'package:clean_bloc_supabase/core/network/connection_checker.dart';
import 'package:clean_bloc_supabase/core/supabase/secrets.dart';
import 'package:clean_bloc_supabase/feature/auth/data/data_sources/auth_supabase_data_source.dart';
import 'package:clean_bloc_supabase/feature/auth/data/repositories/auth_repository_implementation.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/repository/auth_repository.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/current_user.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/user_log_in.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_bloc_supabase/feature/blog/data/data_sources/blog_hive_data_sources.dart';
import 'package:clean_bloc_supabase/feature/blog/data/data_sources/blog_supabase_data_sources.dart';
import 'package:clean_bloc_supabase/feature/blog/data/repositories/blog_repository_implementation.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/repository/blog_repository.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/usecases/get_all_blogs.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/usecases/upload_blog.dart';
import 'package:clean_bloc_supabase/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt dependencyInjector = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize Hive
  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);

  // Open the blogs box
  await Hive.openBox<Map>('blogs');

  _initAuth();
  _initBlog();
  final supabse = await Supabase.initialize(
    url: Secrets.url,
    anonKey: Secrets.publishableAPIKey,
  );
  dependencyInjector.registerLazySingleton(() => supabse.client);
  dependencyInjector.registerFactory(() => InternetConnection());
  dependencyInjector.registerLazySingleton(() => Hive.box('blogs'));

  // Core
  dependencyInjector.registerLazySingleton(() => AppUserCubit());
  dependencyInjector.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImplementation(
      internetConnection: dependencyInjector(),
    ),
  );
}

void _initAuth() {
  // Data Source
  dependencyInjector
    ..registerFactory<AuthSupabaseDataSource>(
      () => AuthSupabaseDataSourceImplementation(
        dependencyInjector<SupabaseClient>(),
      ),
    )
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImplementation(
        dependencyInjector<AuthSupabaseDataSource>(),
        dependencyInjector<ConnectionChecker>(),
      ),
    )
    // Use cases
    ..registerFactory(() => UserSignUp(authRepository: dependencyInjector()))
    ..registerFactory(() => UserLogin(authRepository: dependencyInjector()))
    ..registerFactory(() => CurrentUser(dependencyInjector()))
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: dependencyInjector<UserSignUp>(),
        userLogin: dependencyInjector<UserLogin>(),
        currentUser: dependencyInjector<CurrentUser>(),
        appUserCubit: dependencyInjector<AppUserCubit>(),
      ),
    );
}

void _initBlog() {
  // Data sources
  dependencyInjector
    ..registerFactory<BlogSupabaseDataSources>(
      () => BlogSupabaseDataSourceImplementation(
        supabaseClient: dependencyInjector(),
      ),
    )
    ..registerFactory<BlogHiveDataSources>(
      () => BlogHiveDataSourceImplementation(),
    )
    //Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImplementation(
        blogHiveDataSources: dependencyInjector(),
        blogSupabaseDataSources: dependencyInjector(),
        internetConnectionChecker: dependencyInjector(),
      ),
    )
    // Use cases
    ..registerFactory(() => UploadBlog(blogRepository: dependencyInjector()))
    ..registerFactory(() => GetAllBlogs(blogRepository: dependencyInjector()))
    // ..registerFactory(() => GetBlogById(blogRepository: dependencyInjector()))
    // Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: dependencyInjector(),
        getAllBlogs: dependencyInjector(),
        // getBlogById: dependencyInjector(),
      ),
    );
}
