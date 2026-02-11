import 'package:clean_bloc_supabase/core/cubit/app_user/app_user_cubit.dart';
import 'package:clean_bloc_supabase/core/di/init_dependencies.dart';
import 'package:clean_bloc_supabase/core/go_router/app_router.dart';
import 'package:clean_bloc_supabase/core/theme/app_theme.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_bloc_supabase/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => dependencyInjector<AppUserCubit>()),
        BlocProvider(create: (_) => dependencyInjector<AuthBloc>()),
        BlocProvider(create: (_) => dependencyInjector<BlogBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

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
