import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signin.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  final UserSignin _userSignin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignup userSignup,
    required UserSignin userSignin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignup = userSignup,
        _userSignin = userSignin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_signUp);
    on<AuthSignIn>(_signIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _signUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final response = await _userSignup(
      SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _signIn(AuthSignIn event, Emitter<AuthState> emit) async {
    final response = await _userSignin(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final response = await _currentUser(NoParams());
    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
