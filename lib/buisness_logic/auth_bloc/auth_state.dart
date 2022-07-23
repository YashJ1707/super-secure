part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthenticateState extends AuthState {
  List<Object?> get props => [];
}

class AuthenticationSuccessState extends AuthState {
  List<Object?> get props => [];
}

class SetPasscodeState extends AuthState {
  List<Object?> get props => [];
}
class PasscodeIncorrectState extends AuthState {
  List<Object?> get props => [];
}
