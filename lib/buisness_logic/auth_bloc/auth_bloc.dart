import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:super_secure/data/repositories/auth_api.dart';
import 'package:super_secure/data/util/secure_storage.dart';
import 'package:super_secure/presentation/home_page.dart';
import 'package:toast/toast.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthenticateState()) {
    on<AuthenticatebyBiometricEvent>((event, emit) async {
      if (await SecureStorage.getPassCode() == null) {
        emit(SetPasscodeState());
      } else {
        final isAuthenticated = await AuthApi.authenticate();
        if (isAuthenticated == true) {
          emit(AuthenticationSuccessState());
        }
      }
    });

    on<SetPasscodeEvent>((event, emit) async {
      try {
        await SecureStorage.setPasscode(event.passcode);

        if (await SecureStorage.getPassCode() != null) {
          Toast.show("Passcode set Successfully!",
              duration: Toast.lengthShort, gravity: Toast.bottom);

          emit(AuthenticateState());
        }
      } catch (e) {
        event.passcode == "";
        print(e);
      }
    });

    on<AuthenticatebyPasscode>((event, emit) async {
      try {
        String? passcode = await SecureStorage.getPassCode();
        if (event.passcode == passcode) {
          emit(AuthenticationSuccessState());
        } else {
          emit(PasscodeIncorrectState());
          emit(AuthenticateState());
        }
      } catch (e) {
        print(e);
      }
    });
  }
}
