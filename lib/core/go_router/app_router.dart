import 'package:clean_bloc_supabase/core/cubit/app_user/app_user_cubit.dart';
import 'package:clean_bloc_supabase/core/go_router/route_constants.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/screens/home_screen.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/screens/login_screen.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  GoRouter get router => GoRouter(
    routes: [
      GoRoute(
        name: RouteConstants.home,
        path: '/',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const HomeScreen()),
      ),
      GoRoute(
        name: RouteConstants.login,
        path: '/login',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const LoginScreen()),
      ),
      GoRoute(
        name: RouteConstants.signup,
        path: '/signUp',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SignupScreen()),
      ),
    ],
    initialLocation: RouteConstants.login,
    redirect: (context, state) {
      final isAuthenticated = authBloc.state is AppUserLoggedIn;
      // final isAuthenticated = false;
      // final isLoginRoute = state.path == '/login';

      // If not authenticated and not on login/signup routes, redirect to login
      if (!isAuthenticated) {
        return state.namedLocation(RouteConstants.login);
      }

      // If authenticated and on login/signup routes, redirect to home
      if (isAuthenticated) {
        return state.namedLocation(RouteConstants.home);
      }

      return null;
    },
    errorPageBuilder: (context, state) =>
        const MaterialPage(child: Center(child: Text('Error 404'))),
  );
}
