import 'package:flutter/material.dart';

import 'package:flutter_application_1/gradient_container.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 120, 142, 91),
        body: GradientContainer(
          Color.fromARGB(255, 232, 152, 182),
          Color.fromARGB(255, 238, 177, 98),
        ),
      ),
    ),
  );
}
