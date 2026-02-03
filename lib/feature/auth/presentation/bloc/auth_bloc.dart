import 'package:clean_bloc_supabase/core/cubit/app_user/app_user_cubit.dart';
import 'package:clean_bloc_supabase/core/usecase/usecase.dart';
import 'package:clean_bloc_supabase/core/entities/user.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/current_user.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/user_log_in.dart';
import 'package:clean_bloc_supabase/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_logger/pretty_logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    // on<AuthSignUp>((event, emit) async {
    //   final res = await _userSignUp.call(
    //     UserSignupParameters(
    //       email: event.email,
    //       name: event.name,
    //       password: event.password,
    //     ),
    //   );

    //   res.fold(
    //     (failure) => emit(AuthFailure(failure.message)),
    //     (user) => emit(AuthSuccess(user)),
    //   );
    // });

    // on<AuthLogin>((event, emit) async {
    //   final res = await _userLogin.call(
    //     UserLoginParameters(email: event.email, password: event.password),
    //   );

    //   res.fold(
    //     (failure) => emit(AuthFailure(failure.message)),
    //     (user) => emit(AuthSuccess(user)),
    //   );
    // });
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(
      UserSignupParameters(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthUser(user, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(
      UserLoginParameters(email: event.email, password: event.password),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) =>
          (user) => _emitAuthUser(user, emit),
    );
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold((l) => emit(AuthFailure(l.message)), (r) {
      Logger.green(r.email);
      _emitAuthUser(r, emit);
    });
  }

  void _emitAuthUser(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
