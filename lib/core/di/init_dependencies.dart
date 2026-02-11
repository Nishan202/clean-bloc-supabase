import 'package:clean_bloc_supabase/core/cubit/app_user/app_user_cubit.dart';
import 'package:clean_bloc_supabase/core/supabase/secrets.dart';
import 'package:clean_bloc_supabase/feature/auth/data/data_sources/auth_supabase_data_source.dart';
import 'package:clean_bloc_supabase/feature/auth/data/repositories/auth_repository_implementation.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/repository/auth_repository.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/current_user.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/user_log_in.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_bloc_supabase/feature/blog/data/data_sources/blog_supabase_data_sources.dart';
import 'package:clean_bloc_supabase/feature/blog/data/repositories/blog_repository_implementation.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/repository/blog_repository.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/usecases/get_all_blogs.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/usecases/get_blog_by_id.dart';
import 'package:clean_bloc_supabase/feature/blog/domain/usecases/upload_blog.dart';
import 'package:clean_bloc_supabase/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt dependencyInjector = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabse = await Supabase.initialize(
    url: Secrets.url,
    anonKey: Secrets.publishableAPIKey,
  );
  dependencyInjector.registerLazySingleton(() => supabse.client);
  dependencyInjector.registerLazySingleton(() => AppUserCubit());
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
  // Data source
  dependencyInjector
    ..registerFactory<BlogSupabaseDataSources>(
      () => BlogSupabaseDataSourceImplementation(
        supabaseClient: dependencyInjector(),
      ),
    )
    //Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImplementation(
        blogSupabaseDataSources: dependencyInjector(),
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
