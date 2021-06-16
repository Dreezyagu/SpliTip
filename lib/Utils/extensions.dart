import 'package:flutter/material.dart';

extension CustomContext on BuildContext {
  double height([double percent = 1]) =>
      MediaQuery.of(this).size.height * percent;

  double width([double percent = 1]) =>
      MediaQuery.of(this).size.width * percent;
}
