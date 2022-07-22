import 'package:flutter/material.dart';
import 'package:super_secure/data/repositories/api.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: ElevatedButton(
          child: Text('Authenticate'),
          onPressed: () async {
            final isAuthenticated = AuthApi.authenticate();
            print(isAuthenticated);
          },
        ),
      )),
    );
  }
}
