import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CommonLogo extends StatelessWidget {
  const CommonLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       Image.network(
       "https://i.ibb.co/4dQj2LZ/avengers-logo.png", // Test this URL
    width: 100,
  ),
        "To-Do App".text.xl2.italic.make(),
        "Make A List of your task".text.light.white.wider.lg.make(),
      ],
    );
  }
}