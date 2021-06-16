import 'dart:async';

import 'package:flutter/material.dart';
import 'package:splitip/Utils/extensions.dart';
import 'package:splitip/Utils/constants.dart';
import 'package:splitip/Utils/spaces.dart';

import 'homepage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: TweenAnimationBuilder(
        duration: Duration(milliseconds: 1000),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon.jpg',
                height: context.height(.15),
              ),
              Hspace(context.height(.03)),
              Opacity(
                opacity: value,
                child: Text(
                  "SpliTip Calculator",
                  style: TextStyle(
                      color: white,
                      fontSize: context.width(.07),
                      fontWeight: FontWeight.w900),
                ),
              ),
              Hspace(context.height(.015)),
              TweenAnimationBuilder(
                duration: Duration(milliseconds: 2000),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, _) => Opacity(
                  opacity: value,
                  child: Text(
                    "You really do not have to rack your brain anymore",
                    style: TextStyle(
                        color: white,
                        fontSize: context.width(.035),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
