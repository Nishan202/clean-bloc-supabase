import 'package:clean_bloc_supabase/core/go_router/route_constants.dart';
import 'package:clean_bloc_supabase/core/theme/app_pallete.dart';
import 'package:clean_bloc_supabase/core/utils/show_snackbar.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/custom_widgets/common_elevated_button.dart';
import 'package:clean_bloc_supabase/feature/auth/presentation/custom_widgets/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign In.',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  CommonTextField(
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 20),
                  CommonElevatedButton(
                    isLoading: state is AuthLoading,
                    buttonText: 'Sign in',
                    onPressed: () {
                      // if (formKey.currentState!.validate()) {
                      //   context.read<AuthBloc>().add(
                      //     AuthLogin(
                      //       email: emailController.text.trim(),
                      //       password: passwordController.text.trim(),
                      //     ),
                      //   );
                      // }
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      context.goNamed(RouteConstants.signup);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
