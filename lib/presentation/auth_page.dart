import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_secure/buisness_logic/auth_bloc/auth_bloc.dart';
import 'package:super_secure/data/util/secure_storage.dart';
import 'package:super_secure/presentation/home_page.dart';
import 'package:super_secure/widgets/input_fields.dart';
import 'package:toast/toast.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return BlocProvider(
        create: (context) => AuthBloc()..add(AuthenticatebyBiometricEvent()),
        child: Scaffold(
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is PasscodeIncorrectState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    snackbar(Colors.red, "Invalid Pin! Please try again"));
              }
              if (state is AuthenticationSuccessState) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              }
            },
            builder: (context, state) {
              //For initial password registration or
              //If password gets deleted somehow
              if (state is SetPasscodeState) {
                return buildSetPasscodePage(context);
              }
              //If the user has already registered
              if (state is AuthenticateState) {
                return buildLoginPage(
                  context,
                );
              }

              return Container();
            },
          ),
        ));
  }

  Padding buildLoginPage(BuildContext context) {
    TextEditingController passcodeController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getLoginSecurityIcon(),
          const SizedBox(height: 10),
          getLoginSubtitle(),
          const Spacer(),
          buildPasscodeInputField(context, passcodeController),
          const SizedBox(height: 15),
          buildBiometricAuthenticationButton(context),
          biuldResetPasscodeButton(context),
          const Spacer(),
        ],
      ),
    );
  }

  Row biuldResetPasscodeButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () async {
              SecureStorage.deletePassCode();
              //to trigger bloc
              context.read<AuthBloc>().add(AuthenticatebyBiometricEvent());
            },
            child: const Text(
              'Reset Password?',
              style: TextStyle(fontSize: 12),
            )),
      ],
    );
  }

  InkWell buildBiometricAuthenticationButton(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AuthBloc>().add(AuthenticatebyBiometricEvent());
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        decoration:
            BoxDecoration(border: Border.all(width: 2, color: Colors.teal)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(Icons.fingerprint_outlined),
            SizedBox(width: 8),
            Text('Login with Biometrics',
                style: TextStyle(
                  color: Colors.teal,
                ))
          ]),
        ),
      ),
    );
  }

  InputField buildPasscodeInputField(
      BuildContext context, TextEditingController passcodeController) {
    return InputField(
        onPressed: () {
          context
              .read<AuthBloc>()
              .add(AuthenticatebyPasscode(passcode: passcodeController.text));
        },
        percentOfWidth: 80,
        suffixButton: true,
        controller: passcodeController,
        label: "Enter Pin",
        validator: ((val) {
          if (val?.length == 6) {
            var passcode = passcodeController.text;
            FocusScope.of(context).nextFocus();
            passcodeController.clear();
            context
                .read<AuthBloc>()
                .add(AuthenticatebyPasscode(passcode: passcode));
          }
        }));
  }

  Text getLoginSubtitle() {
    return const Text(
      "Authenticate with Fingerprint or Passcode",
      style: TextStyle(
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  Icon getLoginSecurityIcon() {
    return const Icon(
      Icons.security_sharp,
      size: 80,
    );
  }

  Center buildSetPasscodePage(BuildContext context) {
    TextEditingController passcodeController = TextEditingController();
    TextEditingController confirmPasscodeController = TextEditingController();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getSecurityIcon(),
            const SizedBox(height: 10),
            getWelcomeText(),
            const SizedBox(height: 20),
            getPasscodeSubtitle(),
            const Spacer(),
            getPasscodeInputField(passcodeController),
            getConfimPasscodeInputField(
                confirmPasscodeController, passcodeController),
            buildRegisterButton(isValidated, passcodeController,
                confirmPasscodeController, context),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  bool isValidated(TextEditingController passcodeController,
      TextEditingController confirmPasscodeController) {
    if (passcodeController.text == confirmPasscodeController.text &&
        passcodeController.text.length == 6 &&
        passcodeController.text != "") {
      return true;
    } else {
      return false;
    }
  }

  ElevatedButton buildRegisterButton(
      bool isValidated(TextEditingController passcodeController,
          TextEditingController confirmPasscodeController),
      TextEditingController passcodeController,
      TextEditingController confirmPasscodeController,
      BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (isValidated(passcodeController, confirmPasscodeController) ==
              false) {
            Toast.show("Please enter correct Credentials");
          } else {
            context
                .read<AuthBloc>()
                .add(SetPasscodeEvent(passcode: passcodeController.text));
          }
        },
        child: const Text('Submit'));
  }

  InputField getConfimPasscodeInputField(
      TextEditingController confirmPasscodeController,
      TextEditingController passcodeController) {
    return InputField(
        percentOfWidth: 70,
        controller: confirmPasscodeController,
        label: "Confirm Passcode",
        validator: ((val) {
          if (val?.length != 6 ||
              passcodeController.text != confirmPasscodeController.text) {
            return "Passcodes do not match";
          }
          if (val == "") {
            return "Can't be empty";
          }
          return null;
        }));
  }

  InputField getPasscodeInputField(TextEditingController passcodeController) {
    return InputField(
        percentOfWidth: 70,
        controller: passcodeController,
        label: "Passcode",
        validator: ((val) {
          if (val?.length != 6) {
            return "Code Length should be 6";
          }

          return null;
        }));
  }

  Icon getSecurityIcon() {
    return const Icon(
      Icons.security_sharp,
      size: 80,
    );
  }

  Text getPasscodeSubtitle() {
    return const Text(
      "Set a 6 digit Passcode for Login",
      style: TextStyle(
        fontSize: 14,
      ),
    );
  }

  Text getWelcomeText() {
    return const Text(
      "Welcome",
      style: TextStyle(
        fontSize: 24,
      ),
      textAlign: TextAlign.center,
    );
  }

  SnackBar snackbar(Color color, String text) {
    return SnackBar(
      backgroundColor: color,
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
