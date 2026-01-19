import 'package:clean_bloc_supabase/core/supabase/secrets.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
