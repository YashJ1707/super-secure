import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_secure/buisness_logic/home_bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: BlocProvider(
                create: (context) => HomeBloc()..add(LoadApiEvent()),
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is HomeLoadedState) {
                      return Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.red,
                        ),
                      );
                    }
                    // if (state is SetPasscodeState) {
                    //   return Scaffold(
                    //     body: SafeArea(
                    //         child: Center(
                    //       child: ElevatedButton(
                    //         child: Text('Set Passcode'),
                    //         onPressed: () {
                    //           // context.read<HomeBloc>().add(SetPasscodeEvent());
                    //         },
                    //       ),
                    //     )),
                    //   );
                    // }
                    // if (state is AuthState) {
                    //   return Scaffold(
                    //     backgroundColor: Colors.green,
                    //   );
                    // }
                    return Container();
                  },
                ))));
  }
}
