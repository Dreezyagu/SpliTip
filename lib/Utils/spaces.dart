import 'package:flutter/material.dart';

class Hspace extends StatelessWidget {
  final double height;
  Hspace(this.height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class Wspace extends StatelessWidget {
  final double width;
  Wspace(this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
