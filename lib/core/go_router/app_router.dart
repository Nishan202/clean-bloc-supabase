import 'package:clean_bloc_supabase/core/go_router/route_constants.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/screens/login_screen.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  GoRouter router = GoRouter(
    routes: [
      // GoRoute(
      //   name: RouteConstants.home,
      //   path: '/',
      //   pageBuilder: (context, state) =>
      //       MaterialPage(key: state.pageKey, child: const HomeScreen()),
      // ),
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
    redirect: (context, state) async {
      final isAuthenticated = false;
      if (!isAuthenticated && state.path == '/') {
        return state.namedLocation(RouteConstants.login);
      }
      return null;
    },
    errorPageBuilder: (context, state) =>
        const MaterialPage(child: Center(child: Text('Error 404'))),
  );
}
