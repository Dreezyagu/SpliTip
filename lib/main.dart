import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitip/Screens/splash.dart';
import 'package:splitip/Utils/constants.dart';
import 'package:splitip/cubit/splitip_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplitipCubit()),
      ],
      child: BlocBuilder<SplitipCubit, SplitipState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SpliTip',
            theme: ThemeData(
              fontFamily: "Nunito",
              primaryColor: primary,
            ),
            home: Splash(),
          );
        },
      ),
    );
  }
}
