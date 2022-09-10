import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_secure/buisness_logic/auth_bloc/auth_bloc.dart';
import 'package:super_secure/presentation/auth_page.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.teal,
            buttonTheme: const ButtonThemeData(buttonColor: Colors.teal),
            iconTheme: const IconThemeData(color: Colors.teal)),
        home: const AuthPage(),
      ),
    );
  }
}
