import 'package:clean_bloc_supabase/core/go_router/app_router.dart';
import 'package:clean_bloc_supabase/core/supabase/secrets.dart';
import 'package:clean_bloc_supabase/core/theme/app_theme.dart';
import 'package:clean_bloc_supabase/feature/auth/data/data_sources/auth_supabase_data_source.dart';
import 'package:clean_bloc_supabase/feature/auth/data/repositories/auth_repository_implementation.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabse = await Supabase.initialize(
    url: Secrets.url,
    anonKey: Secrets.publishableAPIKey,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            userSignUp: UserSignUp(
              authRepository: AuthRepositoryImplementation(
                AuthSupabaseDataSourceImplementatin(supabse.client),
              ),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final authBloc = context.read<AuthBloc>();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      routerConfig: AppRouter(authBloc: context.read<AuthBloc>()).router,
      // routerConfig: AppRouter().router,
    );
  }
}
