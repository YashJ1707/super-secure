part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthenticatebyBiometricEvent extends AuthEvent {
  List<Object> get props => [];
}

class AuthenticatebyPasscode extends AuthEvent {
  final String passcode;

  AuthenticatebyPasscode({required this.passcode});
  List<Object> get props => [];
}

class SetPasscodeEvent extends AuthEvent {
  final String passcode;

  SetPasscodeEvent({required this.passcode});

  List<Object> get props => [];
}
